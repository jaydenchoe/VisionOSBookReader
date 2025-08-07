# VisionOS BookReader - Quick Reference Guide

## Essential Components at a Glance

### 🎯 Main App Structure
```swift
BookReaderApp -> ContentView -> [GeneratedImagePanelView, ChatPanelView]
```

### 📚 Core Functions

#### Book Management
```swift
// Load different language books
selectedBookIndex = 0  // Korean
selectedBookIndex = 1  // Japanese  
selectedBookIndex = 2  // English

// Navigate pages
currentPageIndex += 1  // Next page
currentPageIndex -= 1  // Previous page
```

#### Background Music
```swift
@StateObject private var musicViewModel = BackgroundMusicViewModel()

musicViewModel.play()   // Start music
musicViewModel.stop()   // Stop music
```

#### Image Generation
```swift
@StateObject private var imageViewModel = GeneratedImageViewModel()

// Generate from current page
await imageViewModel.generateImage(from: pageContent)

// Toggle between DALL-E and Stable Diffusion
imageViewModel.toggleGenerator()
```

#### AI Chat
```swift
@StateObject private var chatViewModel = ChatViewModel()

// Set context and send message
chatViewModel.currentPageContent = currentPageContent
chatViewModel.userInput = "Your question here"
chatViewModel.sendMessage()
```

### 🔧 Common Patterns

#### Error Handling
```swift
do {
    let result = try await someAsyncFunction()
} catch ImageGenerationService.GenerationError.apiKeyMissing {
    // Handle missing API key
} catch {
    // Handle other errors
}
```

#### State Management
```swift
@State private var currentPageIndex = 0
@State private var showRightPanel = false
@State private var leftPanelMode: LeftPanelMode = .showingImage
```

#### Async Operations
```swift
Task {
    await imageViewModel.generateImage(from: text)
}
```

### 📋 Setup Checklist

- [ ] Add `apikey.txt` with OpenAI API key
- [ ] Configure MCP server endpoints
- [ ] Set up TCP connection for Ollama chat
- [ ] Add background music file (`snowy-269988.mp3`)

### 🚀 Quick Integration Examples

#### Add Image Generation to Any View
```swift
struct MyView: View {
    @StateObject private var imageVM = GeneratedImageViewModel()
    
    var body: some View {
        VStack {
            if let imageURL = imageVM.imageURLString {
                AsyncImage(url: URL(string: imageURL))
            }
            
            Button("Generate") {
                Task { await imageVM.generateImage(from: "prompt") }
            }
        }
    }
}
```

#### Add Chat to Any View
```swift
struct MyView: View {
    @StateObject private var chatVM = ChatViewModel()
    
    var body: some View {
        VStack {
            ForEach(chatVM.messages) { message in
                Text(message.content)
                    .foregroundColor(message.isUser ? .blue : .gray)
            }
            
            TextField("Message", text: $chatVM.userInput)
            Button("Send") { chatVM.sendMessage() }
        }
    }
}
```

### 📡 API Endpoints

#### DALL-E
- **URL**: `https://api.openai.com/v1/images/generations`
- **Method**: POST
- **Auth**: Bearer token

#### MCP Server (Stable Diffusion)
- **Default**: `https://your-server.com/mcp`
- **Method**: POST
- **Format**: JSON-RPC

#### Ollama Chat (TCP)
- **Default**: `your-server.com:12057`
- **Protocol**: TCP
- **Format**: Plain text

### 🎨 UI Components

#### Ornaments (VisionOS specific)
```swift
.ornament(
    visibility: .visible,
    attachmentAnchor: .scene(.leading)
) {
    Button("Action") { /* ... */ }
}
```

#### Glass Background Effect
```swift
.glassBackgroundEffect()
```

#### Page-style TabView
```swift
TabView(selection: $currentPageIndex) {
    ForEach(pages.indices, id: \.self) { index in
        Text(pages[index])
            .tag(index)
    }
}
.tabViewStyle(.page(indexDisplayMode: .never))
```

This quick reference covers the most commonly used APIs and patterns in the VisionOS BookReader app.