```markdown
# VisionOSBookReader (XR "Live" Book)

## 목차

* [소개](#소개)
* [주요 기능](#주요-기능)
* [수상](#수상)
* [아키텍처](#아키텍처)
* [기술 스택](#기술-스택)
* [설정 방법](#설정-방법)
    * [API 키](#api-키)
    * [MCP 서버 (로컬/원격)](#mcp-서버-로컬원격)
* [사용 방법](#사용-방법)
* [추후 계획](#추후-계획)
* [개발 과정에서 얻은 점](#개발-과정에서-얻은-점)

## 소개

VisionOSBookReader는 Apple Vision Pro를 위한 몰입형 멀티미디어 독서 경험을 제공하는 애플리케이션입니다. 이 프로젝트는 기존의 책 읽기 방식을 혁신하여, 사용자가 소설의 장면에 맞는 이미지를 생성하고, 내용에 기반한 AI 어시스턴트와 대화하며 더욱 풍부하고 생동감 넘치는 독서 경험을 할 수 있도록 설계되었습니다. [cite: 2]

텍스트를 읽는 것을 넘어, 각 페이지의 내용에 따라 DALL-E 또는 Stable Diffusion을 통해 이미지가 생성되어 시각적인 즐거움을 더합니다. [cite: 3] 또한, Ollama 기반의 AI 에이전트와 현재 읽고 있는 페이지 내용에 대해 대화할 수 있는 기능을 제공합니다.

## 주요 기능

* **다국어 책 읽기**: 한국어, 일본어, 영어로 된 책을 선택하여 읽을 수 있습니다. (`ContentView.swift`)
* **페이지 네비게이션**: 편리한 페이지 넘김 기능을 제공합니다. (`ContentView.swift`)
* **배경 음악 재생**: 독서 경험을 위한 배경 음악을 재생하고 멈출 수 있습니다. (`BackgroundMusicViewModel.swift`)
* **AI 기반 이미지 생성**:
    * 현재 페이지 내용에 기반하여 DALL-E 3 또는 Stable Diffusion (MCP 서버 연동)을 통해 이미지를 생성합니다. (`GeneratedImagePanelView.swift`)
    * 생성된 이미지를 앱 내 좌측 패널에 표시합니다. (`GeneratedImagePanelView.swift`)
    * DALL-E API 키 설정이 필요하며, Stable Diffusion은 로컬 또는 원격 MCP 서버를 통해 연동됩니다.
* **AI 리더 어시스턴트 (챗봇)**:
    * 현재 페이지의 소설 내용을 기반으로 독자와 대화하는 AI 챗봇 기능을 제공합니다. (`ChatPanelView.swift`)
    * Ollama 모델을 활용하며, TCP를 통해 MCP 서버와 통신합니다. (`ChatPanelView.swift`)
    * 오른쪽 패널을 통해 대화할 수 있습니다. (`ContentView.swift`, `ChatPanelView.swift`)
* **동적 UI 패널**:
    * 이미지 생성 패널 (좌측)과 AI 챗봇 패널 (우측)을 필요에 따라 표시하거나 숨길 수 있습니다. (`ContentView.swift`)

## 수상

* 이 프로젝트의 초기 버전은 2025년 4월 도쿄에서 열린 VisionOS 해커톤에서 "Best Maniac App" 상을 수상했습니다. [cite: 3]

## 아키텍처

이 애플리케이션은 Apple Vision Pro 클라이언트와 백엔드 AI/MCP 서버로 구성됩니다. [cite: 12]

* **클라이언트 (Apple Vision Pro)**:
    * Swift 및 SwiftUI로 개발되었습니다.
    * Swift MCP 클라이언트를 포함하여 MCP 서버와 통신합니다. [cite: 12]
* **백엔드 서버**:
    * **로컬/개인 서버 (예: Mac Studio)**: [cite: 12]
        * Swift MCP 서버 + Ollama (AI 챗봇 기능 제공) [cite: 12]
        * Node.js MCP 서버 + Stable Diffusion (이미지 생성 기능 제공) [cite: 12]
    * **공용 클라우드**: [cite: 14]
        * OpenAI DALL-E 3 (이미지 생성 기능 제공) [cite: 14]
* **MCP (Model Component Protocol)**:
    * 클라이언트와 다양한 AI 모델/도구 서버 간의 통신을 위해 MCP를 활용합니다.
    * `image_generate`, `askOllama` 등의 MCP Tool이 정의되어 사용됩니다. (`GeneratedImagePanelView.swift`, `ChatPanelView.swift`, `3AI-MCP.pdf`)

## 기술 스택

* **클라이언트**: Swift, SwiftUI, VisionOS SDK
* **AI 모델**:
    * 이미지 생성: DALL-E 3 (OpenAI), Stable Diffusion
    * 언어 모델 (챗봇): Ollama (예: Gemma3) [cite: 13]
* **API 및 프로토콜**: OpenAI API, MCP (Model Component Protocol), JSON-RPC, TCP
* **서버 (예시)**: Node.js, Swift (서버 사이드)
* **기타**: AVFoundation (배경 음악), Network (TCP 통신)

## 설정 방법

### API 키

1.  **OpenAI API 키**: DALL-E를 사용한 이미지 생성을 위해서는 OpenAI API 키가 필요합니다.
    * 프로젝트 내 `apikey.txt` 파일에 자신의 OpenAI API 키를 입력합니다. (`GeneratedImagePanelView.swift`, `apikey.txt`)
    * 예시: `sk-YOUR_OPENAI_API_KEY` [cite: 1]

### MCP 서버 (로컬/원격)

Stable Diffusion 이미지 생성 및 Ollama 기반 AI 챗봇 기능을 사용하기 위해서는 MCP 서버 설정이 필요합니다.

1.  **Stable Diffusion MCP 서버**:
    * Node.js 등으로 구현된 MCP 서버를 로컬 또는 원격 환경에 설정하고 Stable Diffusion 모델과 연동합니다.
    * `StableDiffusionService.swift` 내의 `serverURL`을 실제 운영 중인 MCP 서버 주소로 변경해야 할 수 있습니다. (현재 예시: `https://6a00-211-201-154-2.ngrok-free.app/mcp`)
    * PDF 문서의 "MCP Server 개발 방법론" 섹션을 참고하여 MCP 서버를 구축할 수 있습니다. [cite: 25]
2.  **Ollama MCP 서버**:
    * Ollama를 설치하고 원하는 언어 모델(예: Gemma)을 실행합니다.
    * Swift 또는 다른 언어로 구현된 MCP 서버를 통해 Ollama와 연동합니다.
    * `ChatPanelView.swift`의 `sendTCPMessage` 함수 내의 `host` 및 `port`를 실제 운영 중인 TCP 프록시/MCP 서버 주소 및 포트로 변경해야 합니다. (현재 예시: `0.tcp.jp.ngrok.io`, 포트 `12057`)
3.  **NGROK (선택 사항)**:
    * 로컬에서 실행 중인 MCP 서버를 외부(Vision Pro 클라이언트)에서 접근 가능하게 하려면 `ngrok`과 같은 터널링 서비스를 사용할 수 있습니다. [cite: 21, 25]

## 사용 방법

1.  애플리케이션을 실행합니다.
2.  **책 선택**: 상단의 언어 버튼 (한국어, 日本語, English)을 선택하여 읽고 싶은 책을 로드합니다. (`ContentView.swift`)
3.  **페이지 넘기기**: 화면 하단의 좌/우 화살표 버튼(Ornament)을 사용하여 페이지를 넘깁니다. (`ContentView.swift`)
4.  **배경 음악**: 상단의 재생/정지 버튼을 사용하여 배경 음악을 제어합니다. (`ContentView.swift`)
5.  **이미지 생성 보기**:
    * 기본적으로 좌측 패널에 현재 페이지 내용에 기반한 이미지가 생성되어 표시됩니다. (`ContentView.swift`, `GeneratedImagePanelView.swift`)
    * 좌측 패널 상단의 `DALL-E` / `SD` 버튼을 눌러 이미지 생성 모델을 전환하고 새로운 이미지를 생성할 수 있습니다. (`GeneratedImagePanelView.swift`)
    * 좌측 Ornament의 아이콘 버튼을 눌러 이미지 패널을 숨기거나 다시 표시할 수 있습니다. (`ContentView.swift`)
6.  **AI 챗봇과 대화하기**:
    * 우측 Ornament의 말풍선 아이콘 버튼을 눌러 챗봇 패널을 엽니다. (`ContentView.swift`)
    * 하단의 입력 필드에 질문이나 대화 내용을 입력하고 전송 버튼을 누릅니다. (`ChatPanelView.swift`)
    * AI는 현재 페이지의 소설 내용을 참고하여 답변합니다. (`ChatPanelView.swift`)

## 추후 계획

PDF 문서에 따르면 다음과 같은 기능들이 계획 중에 있습니다: [cite: 15]

* Gen Movie Model (MCP / Edge) [cite: 15]
* Gen 2D / 3D Model (MCP / Edge) [cite: 15]
* Gen Voice Model (MCP / Edge) [cite: 15]
* Gen Music Model (MCP / Edge) [cite: 15]
* LLM - Tooling Orchestration [cite: 15]
* Avatar / Helper (2D/3D) [cite: 15]
* 디자인, UX 개선 등 [cite: 15]

## 개발 과정에서 얻은 점

PDF 문서 "시행착오 내용과 알게 된 것" 및 "아키텍처 디자인 고려 사항" 섹션에서 다음과 같은 개발 경험과 고려 사항이 공유되었습니다: [cite: 27, 29]

* MCP 프로토콜 구현 규격에 대한 상세한 문서가 부족할 수 있습니다. [cite: 27]
* MCP 프레임워크 자체는 비교적 잘 구성되어 있을 수 있습니다. [cite: 28]
* LLM을 활용한 코딩 시 관련 기술 문서를 충분히 제공하는 것이 중요합니다. [cite: 27]
* 로컬 MCP 서버 구축은 비교적 간단하지만, 외부 서비스로 제공 시 복잡도가 증가합니다. [cite: 27]
* LLM에 의한 MCP 툴링은 시나리오가 간단하지 않을 수 있습니다. [cite: 27]
* 아키텍처 설계 시 서버 범위(단일/다중), 위치(로컬/엣지/클라우드), 개발 환경/언어 통일 여부, 보안, 확장성 등을 고려해야 합니다. [cite: 29, 30, 31]
```
