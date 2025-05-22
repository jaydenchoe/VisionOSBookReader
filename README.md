# VisionOSBookReader (XR "Live" Book)

## 목차

* [소개](#소개)
* [주요 기능](#주요-기능)
* [수상](#수상)
* [아키텍처](#아키텍처)
* [기술 스택](#기술-스택)
* [설정 방법](#설정-방법)
  * [API 키](#api-키)
  * [MCP 서버 로컬원격](#mcp-서버-로컬원격)
* [사용 방법](#사용-방법)
* [추후 계획](#추후-계획)
* [개발 과정에서 얻은 점](#개발-과정에서-얻은-점)

## 소개

VisionOSBookReader는 Apple Vision Pro를 위한 몰입형 멀티미디어 독서 경험을 제공하는 애플리케이션이다. 이 프로젝트는 기존의 책 읽기 방식을 혁신하여 사용자가 소설의 장면에 맞는 이미지를 생성하고 내용에 기반한 AI 어시스턴트와 대화하며 더욱 풍부하고 생동감 넘치는 독서 경험을 할 수 있도록 설계되었다.

텍스트를 읽는 것을 넘어 각 페이지의 내용에 따라 DALL-E 또는 Stable Diffusion을 통해 이미지가 생성되어 시각적인 즐거움을 더한다. 또한 Ollama 기반의 AI 에이전트와 현재 읽고 있는 페이지 내용에 대해 대화할 수 있는 기능을 제공한다.

## 주요 기능

* **다국어 책 읽기**: 한국어 일본어 영어로 된 책을 선택하여 읽을 수 있다. (`ContentView.swift`)
* **페이지 네비게이션**: 편리한 페이지 넘김 기능을 제공한다. (`ContentView.swift`)
* **배경 음악 재생**: 독서 경험을 위한 배경 음악을 재생하고 멈출 수 있다. (`BackgroundMusicViewModel.swift`)
* **AI 기반 이미지 생성**:
    * 현재 페이지 내용에 기반하여 DALL-E 3 또는 Stable Diffusion을 통해 이미지를 생성한다. (`GeneratedImagePanelView.swift`)
    * 생성된 이미지를 앱 내 좌측 패널에 표시한다. (`GeneratedImagePanelView.swift`)
    * DALL-E API 키 설정이 필요하며 Stable Diffusion은 로컬 또는 원격 MCP 서버와 연동된다.
* **AI 리더 어시스턴트 (챗봇)**:
    * 현재 페이지의 소설 내용을 기반으로 독자와 대화하는 AI 챗봇 기능을 제공한다. (`ChatPanelView.swift`)
    * Ollama 모델을 활용하며 TCP를 통해 MCP 서버와 통신한다. (`ChatPanelView.swift`)
    * 오른쪽 패널을 통해 대화할 수 있다. (`ContentView.swift`, `ChatPanelView.swift`)
* **동적 UI 패널**:
    * 이미지 생성 패널(좌측)과 AI 챗봇 패널(우측)을 필요에 따라 표시하거나 숨길 수 있다. (`ContentView.swift`)

## 수상

* 이 프로젝트의 초기 버전은 2025년 4월 도쿄에서 열린 VisionOS 해커톤에서 "Best Maniac App" 상을 수상했다.

## 아키텍처

이 애플리케이션은 Apple Vision Pro 클라이언트와 백엔드 AI/MCP 서버로 구성된다.

* **클라이언트 (Apple Vision Pro)**:
    * Swift 및 SwiftUI로 개발되었다.
    * Swift MCP 클라이언트를 포함하여 MCP 서버와 통신한다.
* **백엔드 서버**:
    * **로컬/개인 서버 (예: Mac Studio)**:
        * Swift MCP 서버 + Ollama (AI 챗봇 기능 제공)
        * Node.js MCP 서버 + Stable Diffusion (이미지 생성 기능 제공)
    * **공용 클라우드**:
        * OpenAI DALL-E 3 (이미지 생성 기능 제공)
* **MCP (Model Component Protocol)**:
    * 클라이언트와 다양한 AI 모델 및 도구 서버 간의 통신을 위해 MCP를 활용한다.
    * `image_generate`, `askOllama` 등의 MCP Tool이 정의되어 사용된다. (`GeneratedImagePanelView.swift`, `ChatPanelView.swift`)

## 기술 스택

* **클라이언트**: Swift, SwiftUI, VisionOS SDK
* **AI 모델**:
    * 이미지 생성: DALL-E 3 (OpenAI), Stable Diffusion
    * 언어 모델 (챗봇): Ollama (예: Gemma3)
* **API 및 프로토콜**: OpenAI API, MCP, JSON-RPC, TCP
* **서버 예시**: Node.js, Swift 서버
* **기타**: AVFoundation (배경 음악), Network 프레임워크 (TCP 통신)

## 설정 방법

### API 키

1. OpenAI API 키가 필요하다.
    * 프로젝트 내 `apikey.txt` 파일에 자신의 OpenAI API 키를 입력한다. (`GeneratedImagePanelView.swift`, `apikey.txt`)
    * 예시: `sk-YOUR_OPENAI_API_KEY`

### MCP 서버 로컬원격

Stable Diffusion 이미지 생성 및 Ollama 기반 AI 챗봇 기능을 사용하기 위해 MCP 서버 설정이 필요하다.

1. **Stable Diffusion MCP 서버**:
    * Node.js 등으로 구현된 MCP 서버를 로컬 또는 원격 환경에 설정하고 Stable Diffusion 모델과 연동한다.
    * `StableDiffusionService.swift` 내의 `serverURL`을 실제 MCP 서버 주소로 수정해야 할 수 있다. 예시: `https://6a00-211-201-154-2.ngrok-free.app/mcp`
2. **Ollama MCP 서버**:
    * Ollama를 설치하고 원하는 언어 모델을 실행한다.
    * Swift 또는 다른 언어로 구현된 MCP 서버를 통해 Ollama와 연동한다.
    * `ChatPanelView.swift`의 `sendTCPMessage` 함수 내 `host` 및 `port` 값을 실 운영 환경의 TCP 주소로 변경한다. 예시: `0.tcp.jp.ngrok.io`, 포트 `12057`
3. **NGROK (선택 사항)**:
    * 로컬 MCP 서버를 외부에서 접근 가능하게 하려면 `ngrok` 등의 터널링 서비스를 사용할 수 있다.

## 사용 방법

1. 애플리케이션을 실행한다.
2. **책 선택**: 상단 언어 버튼을 눌러 읽고 싶은 책을 선택한다. (`ContentView.swift`)
3. **페이지 넘기기**: 화면 하단의 좌우 화살표 버튼을 사용하여 페이지를 넘긴다. (`ContentView.swift`)
4. **배경 음악**: 상단 재생/정지 버튼을 통해 배경 음악을 제어한다. (`ContentView.swift`)
5. **이미지 생성 보기**:
    * 좌측 패널에 현재 페이지 내용 기반의 이미지가 자동 생성되어 표시된다. (`ContentView.swift`, `GeneratedImagePanelView.swift`)
    * `DALL-E` / `SD` 버튼을 눌러 생성 모델을 전환하고 새 이미지를 만들 수 있다. (`GeneratedImagePanelView.swift`)
    * Ornament 아이콘 버튼을 눌러 이미지 패널을 숨기거나 표시할 수 있다. (`ContentView.swift`)
6. **AI 챗봇과 대화하기**:
    * 우측 Ornament의 말풍선 버튼을 눌러 챗봇 패널을 연다. (`ContentView.swift`)
    * 하단 입력 필드에 메시지를 입력하고 전송 버튼을 누른다. (`ChatPanelView.swift`)
    * AI가 현재 페이지의 소설 내용을 참고하여 응답한다. (`ChatPanelView.swift`)

## 추후 계획

* Gen Movie Model (MCP / Edge)
* Gen 2D / 3D Model (MCP / Edge)
* Gen Voice Model (MCP / Edge)
* Gen Music Model (MCP / Edge)
* LLM 기반 툴 오케스트레이션
* 아바타 / 헬퍼 기능 (2D/3D)
* UI 및 UX 개선

## 개발 과정에서 얻은 점

* MCP 프로토콜의 명확한 구현 가이드가 부족한 경우가 있다.
* MCP 프레임워크는 비교적 잘 구성되어 있다.
* LLM 기반 툴을 개발할 때는 관련 기술 문서 제공이 중요하다.
* 로컬 MCP 서버 구축은 단순하지만 외부 서비스 제공 시 복잡성이 증가한다.
* LLM 기반 MCP 툴 시나리오 설계는 단순하지 않다.
* 아키텍처 설계 시 서버 위치, 구성, 보안, 확장성 등을 사전에 고려해야 한다.
