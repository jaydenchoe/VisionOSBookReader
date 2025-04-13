import SwiftUI
import Network

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.isUser == rhs.isUser &&
        lhs.timestamp == rhs.timestamp
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userInput: String = ""
    var currentPageContent: String = "" // 현재 페이지 내용 저장
    
    private func sendTCPMessage(host: String, port: UInt16, message: String, completion: @escaping (String?) -> Void) {
        guard let nwPort = NWEndpoint.Port(rawValue: port) else {
            completion(nil)
            return
        }

        let connection = NWConnection(host: NWEndpoint.Host(host), port: nwPort, using: .tcp)

        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("✅ 연결 성공")
                let data = (message + "\n").data(using: .utf8)!
                connection.send(content: data, completion: .contentProcessed { error in
                    if let error = error {
                        print("❌ 전송 에러: \(error)")
                        completion(nil)
                        connection.cancel()
                        return
                    }
                    self.receiveResponse(connection: connection, completion: completion)
                })
            case .failed(let error):
                print("❌ 연결 실패: \(error)")
                completion(nil)
                connection.cancel()
            default:
                break
            }
        }

        connection.start(queue: .global())
    }
    
    private func receiveResponse(connection: NWConnection, completion: @escaping (String?) -> Void) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 16384) { data, _, isComplete, error in
            if let data = data, !data.isEmpty, let responseString = String(data: data, encoding: .utf8) {
                print("📥 응답 받음: \(responseString)")
                completion(responseString)
            } else if let error = error {
                print("❌ 응답 수신 에러: \(error)")
                completion(nil)
            } else if isComplete {
                print("✅ 연결 종료됨")
                completion(nil)
            }
            connection.cancel()
        }
    }
    
    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: userInput, isUser: true, timestamp: Date())
        messages.append(userMessage)
        
        // 프롬프트 형식 구성
        let formattedPrompt = """
        [시스템 프롬프트]
        너는 북리더 AI 에이전트이다. 화면에 표시되는 소설의 내용을 바탕으로 독자와 대화를 나눈다.  
        소설의 현재 표시 중인 부분을 참고하여 독자의 질문에 답변하거나, 독자와 관련된 대화를 이어나간다. 답변시 사용하는 언어는 아래 독자 메시지에 사용된 언어를 사용한다. 답변은 80자 이내로 한다.

        [현재 화면에 표시 중인 소설 부분]
        \(currentPageContent)

        [독자 메시지]
        \(userInput)

        [AI 답변]
        """
        
        // 디버깅용 프롬프트 출력
        print("📤 Sending prompt to Ollama:")
        print("--------------------")
        print(formattedPrompt)
        print("--------------------")
        
        userInput = ""
        
        let jsonRequest: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "CallTool",
            "params": [
                "name": "askOllama",
                "arguments": ["prompt": formattedPrompt]
            ],
            "id": UUID().uuidString
        ]
        
        // 디버깅용 JSON 요청 출력
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonRequest),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            let errorMessage = Message(content: "Failed to create request", isUser: false, timestamp: Date())
            DispatchQueue.main.async {
                self.messages.append(errorMessage)
            }
            return
        }
        
        // 디버깅용 예쁘게 출력
        if let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonRequest, options: .prettyPrinted),
           let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
            print("📤 JSON-RPC Request:")
            print("--------------------")
            print(prettyJsonString)
            print("--------------------")
        }
        
        sendTCPMessage(
            host: "0.tcp.jp.ngrok.io",
            port: 15558,
            message: jsonString
        ) { response in
            DispatchQueue.main.async {
                // JSON 파싱 및 content 추출
                if let responseData = response?.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let contentArray = result["content"] as? [String],
                   let firstContent = contentArray.first {
                    let aiMessage = Message(
                        content: firstContent,
                        isUser: false,
                        timestamp: Date()
                    )
                    self.messages.append(aiMessage)
                } else {
                    let errorMessage = Message(
                        content: "Failed to parse response",
                        isUser: false,
                        timestamp: Date()
                    )
                    self.messages.append(errorMessage)
                }
            }
        }
    }
}

struct ChatPanelView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isInputFocused: Bool
    @Binding var currentPageContent: String  // Binding으로 변경
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat history
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area (fixed at bottom)
            HStack(spacing: 8) {
                TextField("Type your message...", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                    .focused($isInputFocused)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .disabled(viewModel.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .frame(width: 280)
        .onAppear {
            isInputFocused = true
            viewModel.currentPageContent = currentPageContent
        }
        .onChange(of: currentPageContent) { newContent in
            // 페이지 내용이 변경될 때마다 ViewModel 업데이트
            viewModel.currentPageContent = newContent
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(12)
                .background(message.isUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .cornerRadius(16)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatPanelView(currentPageContent: .constant("This is a sample page content."))
}
