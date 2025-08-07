# VisionOS BookReader - API Documentation

## Table of Contents

1. [Overview](#overview)
2. [Main Components](#main-components)
3. [View Models](#view-models)
4. [Data Models](#data-models)
5. [Services](#services)
6. [Usage Examples](#usage-examples)

## Overview

VisionOS BookReader is an immersive multimedia reading experience application for Apple Vision Pro. This documentation covers all public APIs, functions, and components available in the application.

## Main Components

### ContentView

The main view component that orchestrates the entire reading experience.

```swift
struct ContentView: View
```

**Purpose**: Primary UI container that manages book reading, image generation, and chat functionality.

**Key Properties**:
- `currentPageIndex: Int` - Current page being displayed
- `pages: [String]` - Array of book pages split from full text
- `selectedBookIndex: Int` - Currently selected book (0: Korean, 1: Japanese, 2: English)
- `leftPanelMode: LeftPanelMode` - Controls left panel visibility
- `showRightPanel: Bool` - Controls right panel (chat) visibility

**Key Functions**:

#### `loadSelectedBook()`
```swift
private func loadSelectedBook()
```
Loads the selected book based on `selectedBookIndex` and splits it into pages.

**Usage**:
```swift
// Automatically called when selectedBookIndex changes
// Resets currentPageIndex to 0 and updates pages array
```

#### `splitTextIntoPages(_ text: String, maxCharsPerPage: Int) -> [String]`
```swift
private func splitTextIntoPages(_ text: String, maxCharsPerPage: Int) -> [String]
```
Splits book text into readable pages based on paragraph boundaries.

**Parameters**:
- `text`: Full book text to split
- `maxCharsPerPage`: Maximum characters per page (default: 600)

**Returns**: Array of page strings

**Example**:
```swift
let pages = splitTextIntoPages(BookData.bookText1, maxCharsPerPage: 600)
print("Created \(pages.count) pages")
```

### LeftPanelMode

Enumeration for controlling left panel display state.

```swift
enum LeftPanelMode {
    case idle        // Panel hidden
    case showingImage // Panel showing generated image
}
```

**Usage**:
```swift
@State private var leftPanelMode: LeftPanelMode = .showingImage
```

### GeneratedImagePanelView

Component responsible for AI-powered image generation based on current page content.

```swift
struct GeneratedImagePanelView: View
```

**Purpose**: Displays AI-generated images that match the current page content using DALL-E or Stable Diffusion.

**Key Properties**:
- `currentMode: LeftPanelMode` - Panel display mode
- `currentPageContent: String` - Current page text for image generation

**Example**:
```swift
GeneratedImagePanelView(
    currentMode: .showingImage,
    currentPageContent: pages[currentPageIndex]
)
```

### ChatPanelView

AI-powered chat interface for discussing book content.

```swift
struct ChatPanelView: View
```

**Purpose**: Provides an AI assistant that can discuss the current page content with the reader.

**Key Properties**:
- `currentPageContent: Binding<String>` - Binding to current page content

**Example**:
```swift
ChatPanelView(currentPageContent: .constant(pages[currentPageIndex]))
```

## View Models

### BackgroundMusicViewModel

Manages background music playback during reading.

```swift
class BackgroundMusicViewModel: ObservableObject
```

**Published Properties**:
- `@Published var isPlaying: Bool` - Current playback state

**Methods**:

#### `play()`
```swift
func play()
```
Starts background music playback.

**Example**:
```swift
let musicViewModel = BackgroundMusicViewModel()
musicViewModel.play()
```

#### `stop()`
```swift
func stop()
```
Stops background music and resets to beginning.

**Example**:
```swift
musicViewModel.stop()
```

### GeneratedImageViewModel

Manages AI image generation state and operations.

```swift
class GeneratedImageViewModel: ObservableObject
```

**Published Properties**:
- `@Published var imageURLString: String?` - Generated image URL
- `@Published var isBase64Image: Bool` - Whether image is base64 encoded
- `@Published var isLoading: Bool` - Loading state
- `@Published var errorMessage: String?` - Error message if generation fails
- `@Published var generatorType: ImageGeneratorType` - Current generator (DALL-E or Stable Diffusion)

**Methods**:

#### `generateImage(from text: String)`
```swift
func generateImage(from text: String) async
```
Generates an image based on the provided text content.

**Parameters**:
- `text`: Text content to base image generation on

**Example**:
```swift
@StateObject private var imageViewModel = GeneratedImageViewModel()

// Generate image from current page
await imageViewModel.generateImage(from: currentPageContent)
```

#### `toggleGenerator()`
```swift
func toggleGenerator()
```
Switches between DALL-E and Stable Diffusion generators.

### ChatViewModel

Manages chat functionality and AI communication.

```swift
class ChatViewModel: ObservableObject
```

**Published Properties**:
- `@Published var messages: [Message]` - Chat message history
- `@Published var userInput: String` - Current user input

**Properties**:
- `var currentPageContent: String` - Current page content for AI context

**Methods**:

#### `sendMessage()`
```swift
func sendMessage()
```
Sends user message to AI and receives response.

**Example**:
```swift
@StateObject private var chatViewModel = ChatViewModel()

// Set context and send message
chatViewModel.currentPageContent = currentPageContent
chatViewModel.userInput = "What do you think about this scene?"
chatViewModel.sendMessage()
```

## Data Models

### BookData

Static container for book content in multiple languages.

```swift
struct BookData {
    static let bookText1: String  // Japanese text
    static let bookText2: String  // Korean text  
    static let bookText3: String  // English text
}
```

**Usage**:
```swift
let koreanText = BookData.bookText2
let japaneseText = BookData.bookText1
let englishText = BookData.bookText3
```

### Message

Represents a chat message in the conversation.

```swift
struct Message: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
}
```

**Example**:
```swift
let userMessage = Message(
    content: "Tell me about this character",
    isUser: true,
    timestamp: Date()
)
```

### DALLERequestBody

Request structure for DALL-E API calls.

```swift
struct DALLERequestBody: Codable {
    var model: String = "dall-e-3"
    let prompt: String
    var n: Int = 1
    var size: String = "1024x1792"
    var response_format: String = "url"
    var style: String = "natural"
}
```

### DALLEResponse

Response structure from DALL-E API.

```swift
struct DALLEResponse: Codable {
    struct ImageData: Codable {
        let url: String?
        let revised_prompt: String?
        let b64_json: String?
    }
    let created: Int?
    let data: [ImageData]
}
```

## Services

### ImageGenerationService

Core service for DALL-E image generation.

```swift
class ImageGenerationService
```

**Methods**:

#### `generateImageURL(prompt: String) async throws -> String`
```swift
func generateImageURL(prompt: String) async throws -> String
```
Generates an image URL using DALL-E API.

**Parameters**:
- `prompt`: Text prompt for image generation

**Returns**: URL string of generated image

**Throws**: `GenerationError` for various failure cases

**Example**:
```swift
let service = ImageGenerationService()
do {
    let imageURL = try await service.generateImageURL(prompt: "A snowy mountain scene")
    print("Generated image: \(imageURL)")
} catch {
    print("Generation failed: \(error)")
}
```

### StableDiffusionService

Service for Stable Diffusion image generation via MCP server.

```swift
class StableDiffusionService: ImageGenerationServiceProtocol
```

**Methods**:

#### `generateImage(prompt: String) async throws -> String`
```swift
func generateImage(prompt: String) async throws -> String
```
Generates image using Stable Diffusion through MCP server.

### APIManager

Utility for managing API keys.

```swift
class APIManager
```

**Methods**:

#### `loadAPIKey() -> String?`
```swift
static func loadAPIKey() -> String?
```
Loads OpenAI API key from `apikey.txt` file.

**Returns**: API key string or nil if not found

**Example**:
```swift
if let apiKey = APIManager.loadAPIKey() {
    print("API key loaded successfully")
} else {
    print("API key not found")
}
```

## Usage Examples

### Basic App Setup

```swift
import SwiftUI

@main
struct BookReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Reading a Book

```swift
struct ContentView: View {
    @State private var currentPageIndex = 0
    @State private var selectedBookIndex = 0
    
    var body: some View {
        VStack {
            // Book selection
            Picker("Book", selection: $selectedBookIndex) {
                Text("한국어").tag(0)
                Text("日本語").tag(1)  
                Text("English").tag(2)
            }
            .pickerStyle(.segmented)
            
            // Page navigation
            HStack {
                Button("Previous") {
                    if currentPageIndex > 0 {
                        currentPageIndex -= 1
                    }
                }
                
                Button("Next") {
                    if currentPageIndex < pages.count - 1 {
                        currentPageIndex += 1
                    }
                }
            }
        }
    }
}
```

### Playing Background Music

```swift
struct MusicControlView: View {
    @StateObject private var musicViewModel = BackgroundMusicViewModel()
    
    var body: some View {
        HStack {
            Button(action: { musicViewModel.play() }) {
                Image(systemName: "play.circle.fill")
            }
            
            Button(action: { musicViewModel.stop() }) {
                Image(systemName: "stop.circle.fill")
            }
        }
    }
}
```

### Generating Images

```swift
struct ImageGenerationExample: View {
    @StateObject private var imageViewModel = GeneratedImageViewModel()
    
    var body: some View {
        VStack {
            if imageViewModel.isLoading {
                ProgressView("Generating image...")
            } else if let imageURL = imageViewModel.imageURLString {
                AsyncImage(url: URL(string: imageURL))
            }
            
            Button("Generate Image") {
                Task {
                    await imageViewModel.generateImage(from: "A beautiful landscape")
                }
            }
        }
    }
}
```

### Chat with AI

```swift
struct ChatExample: View {
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            // Message list
            ScrollView {
                ForEach(chatViewModel.messages) { message in
                    MessageBubble(message: message)
                }
            }
            
            // Input field
            HStack {
                TextField("Type message...", text: $chatViewModel.userInput)
                Button("Send") {
                    chatViewModel.sendMessage()
                }
            }
        }
        .onAppear {
            chatViewModel.currentPageContent = "Current page content here"
        }
    }
}
```

### Error Handling

```swift
// Image generation error handling
do {
    let imageURL = try await imageService.generateImageURL(prompt: prompt)
    // Handle success
} catch ImageGenerationService.GenerationError.apiKeyMissing {
    print("Please set up your OpenAI API key")
} catch ImageGenerationService.GenerationError.requestFailed(let error) {
    print("Network error: \(error)")
} catch {
    print("Unexpected error: \(error)")
}
```

### Configuration Requirements

#### API Key Setup
1. Create `apikey.txt` file in your project bundle
2. Add your OpenAI API key: `sk-YOUR_OPENAI_API_KEY`

#### MCP Server Setup
For Stable Diffusion and Ollama functionality:
1. Set up MCP server with appropriate endpoints
2. Update server URLs in `StableDiffusionService.swift` and `ChatPanelView.swift`

**Example server configuration**:
```swift
// In StableDiffusionService.swift
private let serverURL = "https://your-mcp-server.com/mcp"

// In ChatPanelView.swift  
sendTCPMessage(host: "your-server.com", port: 12057, message: prompt)
```

This documentation covers all major public APIs and components in the VisionOS BookReader application. Each component includes usage examples and configuration instructions for easy integration and development.