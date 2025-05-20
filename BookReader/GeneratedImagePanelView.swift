import SwiftUI

// MARK: - Data Structures
struct DALLERequestBody: Codable {
    var model: String = "dall-e-3"
    let prompt: String
    var n: Int = 1
    var size: String = "1024x1792"
    var response_format: String = "url"
    var style: String = "natural"
}

struct DALLEResponse: Codable {
    struct ImageData: Codable {
        let url: String?
        let revised_prompt: String?
        let b64_json: String?
    }
    let created: Int?
    let data: [ImageData]
}

class APIManager {
    static func loadAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "apikey", ofType: "txt") else {
            return nil
        }
        return try? String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Image Generation Service
class ImageGenerationService {
    private let apiKey = APIManager.loadAPIKey()

    private let apiURL = URL(string: "https://api.openai.com/v1/images/generations")!
    
    enum GenerationError: Error, LocalizedError {
        case apiKeyMissing
        case encodingFailed
        case requestFailed(Error)
        case invalidResponse(statusCode: Int, body: String?)
        case decodingFailed(Error)
        case noImageData
        case imageURLMissing

        var errorDescription: String? {
            switch self {
            case .apiKeyMissing: return "OpenAI API Key가 설정되지 않았습니다."
            case .encodingFailed: return "요청 데이터를 만드는데 실패했습니다."
            case .requestFailed(let error): return "네트워크 요청 실패: \(error.localizedDescription)"
            case .invalidResponse(let statusCode, let body):
                return "잘못된 서버 응답 (코드: \(statusCode)). 응답 내용: \(body ?? "없음")"
            case .decodingFailed(let error): return "서버 응답을 해석하는데 실패했습니다: \(error.localizedDescription)"
            case .noImageData: return "서버 응답에 이미지 데이터가 없습니다."
            case .imageURLMissing: return "서버 응답에 이미지 URL이 없습니다."
            }
        }
    }
    
    func generateImageURL(prompt: String) async throws -> String {
        guard let apiKey = APIManager.loadAPIKey(), !apiKey.isEmpty, apiKey != "sk-YOUR_OPENAI_API_KEY" else {
               throw GenerationError.apiKeyMissing
        }

        let requestBody = DALLERequestBody(prompt: prompt)
        let encodedBody: Data
        do {
            encodedBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw GenerationError.encodingFailed
        }
        
        // 커스텀 URLSession 구성 (HTTP/3 우회)
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        config.waitsForConnectivity = true // 연결될 때까지 기다림
        config.httpMaximumConnectionsPerHost = 1 // 연결 수 제한
        
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.httpBody = encodedBody

        // 디버깅을 위한 요청 내용 출력
        if let requestString = String(data: encodedBody, encoding: .utf8) {
            print("📤 Request Body:")
            print(requestString)
        }

        let (data, response) = try await session.data(for: request)
        
        // 디버깅을 위한 응답 내용 출력
        print("📥 Response Data:")
        print(String(data: data, encoding: .utf8) ?? "No response data")
        
        // 응답 디버깅용 추가 로그
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status code: \(httpResponse.statusCode)")
            print("📡 Content-Type: \(httpResponse.allHeaderFields["Content-Type"] ?? "알 수 없음")")
        }
        print("📥 Raw response:")
        print(String(data: data, encoding: .utf8) ?? "응답 없음 또는 인코딩 실패")

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GenerationError.invalidResponse(statusCode: 0, body: "응답이 HTTP 형식이 아닙니다.")
        }

        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8)
            throw GenerationError.invalidResponse(statusCode: httpResponse.statusCode, body: responseBody)
        }

        let decodedResponse: DALLEResponse
        do {
            decodedResponse = try JSONDecoder().decode(DALLEResponse.self, from: data)
        } catch {
            print("JSON Decoding Error: \(error)")
            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
            throw GenerationError.decodingFailed(error)
        }

        guard let imageData = decodedResponse.data.first else {
            throw GenerationError.noImageData
        }

        guard let imageURLString = imageData.url else {
            throw GenerationError.imageURLMissing
        }

        return imageURLString
    }

    // 재시도 로직이 포함된 새 함수 추가
    func generateImageURLWithRetry(prompt: String, maxRetries: Int = 2) async throws -> String {
        var lastError: Error = GenerationError.requestFailed(NSError(domain: "초기화", code: -1))
        
        for attempt in 1...maxRetries {
            do {
                return try await generateImageURL(prompt: prompt)
            } catch {
                print("🚨 Attempt \(attempt) failed with error: \(error.localizedDescription)")
                lastError = error
                try await Task.sleep(nanoseconds: UInt64(1_000_000_000)) // 1초 대기
            }
        }
        
        throw lastError
    }
}

// MARK: - Image Generator Protocol
protocol ImageGenerationServiceProtocol {
    func generateImage(prompt: String) async throws -> String
    func generateImageWithRetry(prompt: String, maxRetries: Int) async throws -> String
}

// MARK: - MCP Server Structures & Service
struct MCPRequest<T: Encodable>: Encodable {
    let jsonrpc: String = "2.0"
    let id: String
    let method: String
    let params: T
}

// 응답이 배열로 감싸져 있으므로 배열로 디코딩
typealias MCPResponses = [MCPResponse]

struct MCPResponse: Codable {
    let jsonrpc: String
    let id: String?
    let result: MCPResult?
    let error: MCPError?
}

struct MCPResult: Codable {
    let content: [MCPContent]?
    let protocolVersion: String?
    let serverInfo: MCPServerInfo?
    
    // capabilities는 JSON으로 직접 처리
    private let _capabilities: String?
    
    var capabilities: [String: Any]? {
        guard let capabilitiesData = _capabilities?.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: capabilitiesData) as? [String: Any]
    }
    
    private enum CodingKeys: String, CodingKey {
        case content, protocolVersion, serverInfo, _capabilities = "capabilities"
    }
}

struct MCPServerInfo: Codable {
    let name: String
    let version: String
}

struct MCPContent: Codable {
    let type: String
    let text: String
}

struct MCPError: Codable {
    let code: Int
    let message: String
}

class StableDiffusionService: ImageGenerationServiceProtocol {
    private let serverURL: URL
    
    init(serverURL: String = "https://6a00-211-201-154-2.ngrok-free.app/mcp") {
        self.serverURL = URL(string: serverURL)!
    }
    
    enum MCPError: Error, LocalizedError {
        case serverURLMissing
        case encodingFailed
        case requestFailed(Error)
        case invalidResponse(statusCode: Int, body: String?)
        case decodingFailed(Error)
        case mcpError(String)
        case noImageData
        
        var errorDescription: String? {
            switch self {
            case .serverURLMissing: return "MCP 서버 URL이 설정되지 않았습니다."
            case .encodingFailed: return "요청 데이터를 만드는데 실패했습니다."
            case .requestFailed(let error): return "네트워크 요청 실패: \(error.localizedDescription)"
            case .invalidResponse(let statusCode, let body):
                return "잘못된 서버 응답 (코드: \(statusCode)). 응답 내용: \(body ?? "없음")"
            case .decodingFailed(let error): return "서버 응답을 해석하는데 실패했습니다: \(error.localizedDescription)"
            case .mcpError(let message): return "MCP 서버 오류: \(message)"
            case .noImageData: return "서버 응답에 이미지 데이터가 없습니다."
            }
        }
    }
    
    // 이미지 생성 - 불필요한 초기화 단계 제거하고 바로 tools/call 호출
    func generateImage(prompt: String) async throws -> String {
        struct ToolCallParams: Encodable {
            let name: String
            let arguments: [String: String]
        }
        
        let callRequest = MCPRequest<ToolCallParams>(
            id: UUID().uuidString,
            method: "tools/call",
            params: ToolCallParams(
                name: "image_generate",
                arguments: ["prompt": prompt]
            )
        )
        
        let responses = try await sendMCPRequest(callRequest)
        
        // 첫 번째 응답 확인
        guard let response = responses.first, let result = response.result else {
            if let error = responses.first?.error {
                throw MCPError.mcpError(error.message)
            }
            throw MCPError.noImageData
        }
        
        // 응답에서 이미지 데이터 추출
        guard let content = result.content?.first,
              let data = content.text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let preview = json["preview"] as? String else {
            throw MCPError.noImageData
        }
        
        return preview
    }
    
    // MCP 요청 보내기 (배열로 디코딩)
    private func sendMCPRequest<T: Encodable>(_ request: MCPRequest<T>) async throws -> MCPResponses {
        let encodedBody: Data
        do {
            let encoder = JSONEncoder()
            encodedBody = try encoder.encode(request)
        } catch {
            print("인코딩 실패: \(error)")
            throw MCPError.encodingFailed
        }
        
        // URLSession 구성
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream"
        ]
        
        let session = URLSession(configuration: config)
        
        var urlRequest = URLRequest(url: serverURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = encodedBody
        
        // 디버깅을 위한 요청 내용 출력
        if let requestString = String(data: encodedBody, encoding: .utf8) {
            print("📤 MCP Request:")
            print(requestString)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        // 디버깅을 위한 응답 내용 출력
        print("📥 MCP Response:")
        print(String(data: data, encoding: .utf8) ?? "No response data")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MCPError.invalidResponse(statusCode: 0, body: "응답이 HTTP 형식이 아닙니다.")
        }
        
        guard httpResponse.statusCode == 200 else {
            let responseBody = String(data: data, encoding: .utf8)
            throw MCPError.invalidResponse(statusCode: httpResponse.statusCode, body: responseBody)
        }
        
        let decodedResponses: MCPResponses
        do {
            let decoder = JSONDecoder()
            decodedResponses = try decoder.decode(MCPResponses.self, from: data)
        } catch {
            print("JSON Decoding Error: \(error)")
            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
            throw MCPError.decodingFailed(error)
        }
        
        return decodedResponses
    }
    
    // 재시도 로직이 포함된 함수 - 단순화
    func generateImageWithRetry(prompt: String, maxRetries: Int = 2) async throws -> String {
        var lastError: Error = MCPError.requestFailed(NSError(domain: "초기화", code: -1))
        
        for attempt in 1...maxRetries {
            do {
                return try await generateImage(prompt: prompt)
            } catch {
                print("🚨 시도 \(attempt) 실패: \(error.localizedDescription)")
                lastError = error
                if attempt < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000)) // 1초 대기
                }
            }
        }
        
        throw lastError
    }
}

// MARK: - DALL-E Service Implementation
class DALLEService: ImageGenerationServiceProtocol {
    private let imageGenerator = ImageGenerationService()
    
    func generateImage(prompt: String) async throws -> String {
        return try await imageGenerator.generateImageURL(prompt: prompt)
    }
    
    func generateImageWithRetry(prompt: String, maxRetries: Int = 2) async throws -> String {
        return try await imageGenerator.generateImageURLWithRetry(prompt: prompt, maxRetries: maxRetries)
    }
}

// MARK: - Image Generator Factory
enum ImageGeneratorType {
    case dalleAI
    case stableDiffusion
}

class ImageGeneratorFactory {
    static func getGenerator(type: ImageGeneratorType) -> ImageGenerationServiceProtocol {
        switch type {
        case .dalleAI:
            return DALLEService()
        case .stableDiffusion:
            return StableDiffusionService()
        }
    }
}

// MARK: - View Model
class GeneratedImageViewModel: ObservableObject {
    @Published var imageURLString: String?
    @Published var isBase64Image: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var generatorType: ImageGeneratorType = .dalleAI
    
    private var imageGenerator: ImageGenerationServiceProtocol {
        ImageGeneratorFactory.getGenerator(type: generatorType)
    }
    
    func generateImage(from text: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        // 텍스트 길이 제한 (100자)
        let truncatedText = text.count > 100 ? String(text.prefix(100)) + "..." : text
        
        let prompt = """
        Create an illustration for novel scene in watercolor style: \(truncatedText)
        Style: Soft watercolor illustration, book illustration style
        Mood: Delicate, artistic, traditional Japanese illustration
        Note: No TEXT, No ROTATION
        """
        
        // 디버깅용 프롬프트 출력
        print("🎨 이미지 생성 프롬프트:")
        print("--------------------")
        print(prompt)
        print("--------------------")
        
        do {
            // 불필요한 초기화 단계 없이 직접 이미지 생성 요청
            let imageResult = try await imageGenerator.generateImageWithRetry(prompt: prompt, maxRetries: 2)
            
            await MainActor.run {
                self.imageURLString = imageResult
                self.isBase64Image = self.generatorType == .stableDiffusion
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("이미지 생성 오류: \(error)")
            }
        }
    }
    
    func toggleGenerator() {
        generatorType = generatorType == .dalleAI ? .stableDiffusion : .dalleAI
        print("이미지 생성기 변경: \(generatorType == .dalleAI ? "DALL-E" : "Stable Diffusion")")
    }
}

// MARK: - View
struct GeneratedImagePanelView: View {
    let currentMode: LeftPanelMode
    let imageName: String = "SampleGeneratedImage"
    @StateObject private var viewModel = GeneratedImageViewModel()
    let currentPageContent: String
    
    var body: some View {
        VStack {
            if currentMode == .showingImage {
                VStack {
                    // 이미지 생성기 전환 버튼
                    HStack {
                        // 이미지 생성기 전환 버튼 가운데 정렬
                        Spacer()
                        Button(action: {
                            viewModel.toggleGenerator()
                            Task {
                                await viewModel.generateImage(from: currentPageContent)
                            }
                        }) {
                            Text(viewModel.generatorType == .dalleAI ? "DALL-E" : "Stable Diffusion")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.secondary.opacity(0.2))
                                .cornerRadius(4)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 8)
                        Spacer()
                    }
                    
                    ZStack {
                        // 생성된 이미지 표시 (DALL-E URL 또는 Stable Diffusion Base64)
                        if viewModel.isBase64Image, 
                           let base64String = viewModel.imageURLString,
                           let imageData = Data(base64Encoded: base64String),
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if !viewModel.isBase64Image,
                                  let urlString = viewModel.imageURLString,
                                  let imageURL = URL(string: urlString) {
                            AsyncImage(url: imageURL) { phase in
                                switch phase {
                                case .empty:
                                    fallbackImage
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    fallbackImage
                                @unknown default:
                                    fallbackImage
                                }
                            }
                        } else {
                            fallbackImage
                        }
                        
                        // 로딩 상태일 때 블러 효과와 로딩 인디케이터
                        if viewModel.isLoading {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            loadingView
                        }
                    }
                }
            } else {
                Spacer()
                Text("Visualize page content here.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }
        }
        .frame(width: 300)
        .glassBackgroundEffect()
        .onAppear {
            // 초기 이미지 생성
            if currentMode == .showingImage {
                Task {
                    await viewModel.generateImage(from: currentPageContent)
                }
            }
        }
        .onChange(of: currentPageContent) { newContent in
            Task {
                await viewModel.generateImage(from: newContent)
            }
        }
    }
    
    private var fallbackImage: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .clipped()
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text("Generating image...")
                .font(.subheadline)
        }
    }
}

// MARK: - Preview
#Preview {
    HStack {
        GeneratedImagePanelView(
            currentMode: .idle,
            currentPageContent: "Sample content"
        )
        GeneratedImagePanelView(
            currentMode: .showingImage,
            currentPageContent: "Sample content"
        )
    }
    .padding()
}
