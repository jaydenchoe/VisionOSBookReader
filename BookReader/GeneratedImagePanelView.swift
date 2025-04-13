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

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = encodedBody

        // 디버깅을 위한 요청 내용 출력
        if let requestString = String(data: encodedBody, encoding: .utf8) {
            print("📤 Request Body:")
            print(requestString)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 디버깅을 위한 응답 내용 출력
        print("📥 Response Data:")
        print(String(data: data, encoding: .utf8) ?? "No response data")

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
}

// MARK: - View Model
class GeneratedImageViewModel: ObservableObject {
    @Published var imageURLString: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let imageGenerator = ImageGenerationService()
    
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
        print("🎨 Generating image with prompt:")
        print("--------------------")
        print(prompt)
        print("--------------------")
        
        do {
            let url = try await imageGenerator.generateImageURL(prompt: prompt)
            await MainActor.run {
                self.imageURLString = url
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error generating image: \(error)")
            }
        }
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
                ZStack {
                    // 기본 이미지 또는 생성된 이미지
                    if let urlString = viewModel.imageURLString,
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
