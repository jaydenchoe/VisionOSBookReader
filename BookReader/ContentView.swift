import SwiftUI

// --- 왼쪽 패널 내용 모드 정의 ---
enum LeftPanelMode {
    case idle // 기본 상태
    case showingImage // 이미지 표시 상태
}

struct ContentView: View {
    @StateObject private var musicViewModel = BackgroundMusicViewModel()
    // BookData.bookText가 BookContent.swift 파일에 정의되어 있다고 가정합니다.

    // --- 상태 변수들 ---
    @State private var currentPageIndex = 0
    @State private var pages: [String] = []
    @State private var generatedImageName: String = "SampleGeneratedImage" // Asset Catalog 이미지 이름
    @State private var leftPanelMode: LeftPanelMode = .showingImage // 시작 시 이미지 표시
    @State private var showRightPanel = false // 오른쪽 패널 내용 표시 여부
    
    // 책 선택을 위한 상태 변수 추가
    @State private var selectedBookIndex = 0
    
    // 책 제목 배열 - 각 언어로 표시
    private let bookTitles = ["한국어", "日本語", "English"]

    var body: some View {
        VStack(spacing: 0) {
            // 상단에 음악 컨트롤과 책 선택 UI 추가
            VStack {
                // 책 선택 세그먼트 컨트롤
                Picker("책 선택", selection: $selectedBookIndex) {
                    ForEach(0..<bookTitles.count, id: \.self) { index in
                        Text(bookTitles[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedBookIndex) { newValue in
                    loadSelectedBook()
                }
                
                // 기존 음악 컨트롤
                HStack {
                    Spacer()
                    Button(action: { musicViewModel.play() }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                    }
                    Button(action: { musicViewModel.stop() }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            
            // --- 메인 가로 스택 ---
            HStack(spacing: 0) {

                // --- 왼쪽 패널 영역 ---
                // leftPanelMode 값에 따라 다른 뷰를 표시하거나 공간 유지
                Group {
                    if leftPanelMode == .showingImage && !pages.isEmpty {  // pages 비어있지 않을 때만
                        GeneratedImagePanelView(
                            currentMode: leftPanelMode,
                            currentPageContent: pages[currentPageIndex]
                        )
                    } else {
                        Color.clear
                            .frame(width: 300) // GeneratedImagePanelView와 동일한 너비 유지
                    }
                }
                .transition(.move(edge: .leading).combined(with: .opacity)) // 패널 내용 전환 애니메이션

                // --- 가운데: 텍스트 표시 TabView ---
                if !pages.isEmpty {  // pages 비어있지 않을 때만
                    TabView(selection: $currentPageIndex) {
                        ForEach(pages.indices, id: \.self) { index in
                            ScrollView {
                                Text(pages[index])
                                    .font(.system(size: 20))
                                    .padding()
                                    .lineSpacing(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 남은 공간 모두 차지
                }

                // --- 오른쪽 패널 영역 수정 ---
                Group {
                    if showRightPanel && !pages.isEmpty {  // pages 비어있지 않을 때만
                        ChatPanelView(currentPageContent: .constant(pages[currentPageIndex]))
                    } else {
                        Color.clear
                            .frame(width: 280)
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))

            } // --- HStack 끝 ---
            .glassBackgroundEffect() // 전체 뷰에 유리 배경 효과

            // --- 왼쪽 Ornament ---
            .ornament(
                visibility: .visible, // 자동 표시/숨김
                attachmentAnchor: .scene(.leading),
                contentAlignment: .center
            ) {
                VStack { // 세로 버튼 배치
                    Button {
                        // 패널 내용 모드 토글
                        if leftPanelMode == .showingImage {
                            leftPanelMode = .idle
                            print("Left Panel content set to IDLE") // 상태 변경 로그
                        } else {
                            leftPanelMode = .showingImage
                            print("Left Panel content set to SHOWING_IMAGE") // 상태 변경 로그
                        }
                    } label: {
                        // 모드에 따른 아이콘 변경
                        Image(systemName: leftPanelMode == .showingImage ? "photo.fill.on.rectangle.fill" : "sparkles")
                    }
                    .padding() // 버튼 패딩
                }
                .padding(.vertical)
                .glassBackgroundEffect() // Ornament 배경
            }

            // --- 하단 Ornament ---
            .ornament(
                visibility: .automatic,
                attachmentAnchor: .scene(.bottom),
                contentAlignment: .center
            ) {
                HStack {
                    // 이전 페이지 버튼
                    Button { if currentPageIndex > 0 { currentPageIndex -= 1 } } label: { Image(systemName: "chevron.left") }
                    .padding().disabled(currentPageIndex == 0)

                    Spacer() // 버튼 간 간격

                    // 다음 페이지 버튼
                    Button { if currentPageIndex < pages.count - 1 { currentPageIndex += 1 } } label: { Image(systemName: "chevron.right") }
                    .padding().disabled(currentPageIndex == pages.count - 1)
                }
                .padding(.horizontal)
                .glassBackgroundEffect() // Ornament 배경
            }

            // --- 오른쪽 Ornament ---
            .ornament(
                visibility: .visible,
                attachmentAnchor: .scene(.trailing),
                contentAlignment: .leading
            ) {
                Button {
                    showRightPanel.toggle()
                    print("Chat button tapped. showRightPanel: \(showRightPanel)")
                } label: {
                    Label("Chat", systemImage: "message")
                }
                .labelStyle(.iconOnly)
                .padding()
                .frame(width: 60)
                .glassBackgroundEffect()
            }
        }

        // 뷰가 나타날 때 페이지 분할
        .onAppear {
            // 첫 번째 책을 기본으로 로드
            loadSelectedBook()
            print("ContentView appeared. Pages loaded: \(pages.count)") // 로딩 로그
        }

        // 상태 변화에 따른 애니메이션 (여전히 문제의 원인일 수 있음)
        .animation(.easeInOut, value: leftPanelMode)
        .animation(.easeInOut, value: showRightPanel)
    } // --- body 끝 ---

    // 선택된 책을 로드하는 함수
    private func loadSelectedBook() {
        let selectedText: String
        
        switch selectedBookIndex {
        case 0:
            selectedText = BookData.bookText2  // 한국어 텍스트
        case 1:
            selectedText = BookData.bookText1  // 일본어 텍스트
        case 2:
            selectedText = BookData.bookText3  // 영어 텍스트
        default:
            selectedText = BookData.bookText2
        }
        
        // 텍스트를 페이지로 분할
        pages = splitTextIntoPages(selectedText, maxCharsPerPage: 600)
        
        // 현재 페이지를 첫 페이지로 리셋
        currentPageIndex = 0
        
        print("책 선택 변경: \(bookTitles[selectedBookIndex]), 페이지 수: \(pages.count)")
    }

    // 페이지 분할 함수
    private func splitTextIntoPages(_ text: String, maxCharsPerPage: Int) -> [String] {
        let paragraphs = text.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        var pages: [String] = []
        var currentPageText = ""
        for paragraph in paragraphs {
            if !currentPageText.isEmpty && currentPageText.count + paragraph.count > maxCharsPerPage {
                pages.append(currentPageText)
                currentPageText = paragraph
            } else {
                if !currentPageText.isEmpty { currentPageText += "\n\n" }
                currentPageText += paragraph
            }
        }
        if !currentPageText.isEmpty {
            pages.append(currentPageText)
        }
        // Handle case where the entire text fits on one page or is empty
        if pages.isEmpty && !text.isEmpty {
             pages.append(text)
        }
        print("Splitting text resulted in \(pages.count) pages.") // 페이지 분할 로그
        return pages
    }

} // --- ContentView 끝 ---

// Preview
#Preview(windowStyle: .automatic) {
    ContentView()
}
