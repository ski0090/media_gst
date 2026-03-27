# SPEC.md: Rust 기반 Flutter 미디어 플레이어 기술 명세

## 1. 아키텍처 개요
- **Frontend**: Flutter (UI 레이어 및 렌더링 레지스트리 관리)
- **Backend Core (Rust Native)**:
    - **`bridge`**: Flutter(FRB) 인터페이스 레이어. 내부적으로 `media_core` 모듈이 통합되어 있으며, 기존의 독립된 core 크레이트 기능을 대체하여 GStreamer 파이프라인 관리 및 핵심 비즈니스 로직을 직접 처리함.
- **Interface**: flutter_rust_bridge v2 (Zero-copy 데이터 전달 및 명령 제어)

## 2. GStreamer 파이프라인 설계
### 2.1 프로토콜별 소스 구성
- **RTSP**: `rtspsrc` -> `rtph264depay` -> `h264parse` -> `decodebin`
- **HLS/MP4**: `souphttpsrc` 또는 `filesrc` -> `decodebin`
- **WebRTC**: `webrtcbin` (Signaling 인터페이스 포함)

### 2.2 비디오 출력 (Sink) 구성
- **Android**: `glimagesink`를 사용하여 `SurfaceTexture`에 직접 바인딩.
- **iOS/macOS**: `metalvidsink` 또는 `caopengllayersink` 활용.
- **Windows/Linux**: `appsrc` / `appsink`를 통한 공유 메모리 처리.

## 3. 핵심 비즈니스 로직
### 3.1 다채널 동시 재생 관리
- 각 채널은 Rust 내에서 고유한 `UUID`를 가진 `PlayerInstance` 객체로 관리됨.
- `tokio::sync::broadcast`를 통해 전체 채널 상태(Play/Pause/Stop)를 동기화.

### 3.2 메모리 최적화 (Zero-Copy)
- GPU 메모리 상의 텍스처 핸들(ID)만을 Dart 측으로 전달하여 CPU 오버헤드 제거.
- `ExternalTexture` API를 활용한 하드웨어 가속 렌더링.