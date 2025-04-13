import SwiftUI

// --- 왼쪽 패널 내용 모드 정의 ---
enum LeftPanelMode {
    case idle // 기본 상태
    case showingImage // 이미지 표시 상태
}

struct ContentView: View {
    // BookData.bookText가 BookContent.swift 파일에 정의되어 있다고 가정합니다.

    // --- 상태 변수들 ---
    @State private var currentPageIndex = 0
    @State private var pages: [String] = []
    @State private var generatedImageName: String = "SampleGeneratedImage" // Asset Catalog 이미지 이름
    @State private var leftPanelMode: LeftPanelMode = .showingImage // 시작 시 이미지 표시
    @State private var showRightPanel = false // 오른쪽 패널 내용 표시 여부

    var body: some View {
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

        // 뷰가 나타날 때 페이지 분할
        .onAppear {
            // 먼저 페이지를 로드하고
            pages = splitTextIntoPages(BookData.bookText, maxCharsPerPage: 600)
            print("ContentView appeared. Pages loaded: \(pages.count)") // 로딩 로그
        }

        // 상태 변화에 따른 애니메이션 (여전히 문제의 원인일 수 있음)
        .animation(.easeInOut, value: leftPanelMode)
        .animation(.easeInOut, value: showRightPanel)

    } // --- body 끝 ---

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
