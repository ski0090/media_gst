## 📄 AGENT.md (Video-Focused Player 정의서)

### 1. 객체 정의: `GstVideoPlayer`

GStreamer 파이프라인을 제어하고, 디코딩된 비디오 프레임을 Flutter의 `Texture` 위젯으로 브릿징하는 핵심 엔진.

### 2. 초기화 파라미터 (Constructor)

렌더링 성능과 하드웨어 자원 할당에 집중합니다.

| 파라미터명 | 타입 | 설명 | 비고 |
| --- | --- | --- | --- |
| `useHardwareAcceleration` | `bool` | GPU 가속 디코딩 사용 여부 | `vaapi`, `d3d11`, `videotoolbox` 등 자동 선택 |
| `pixelFormat` | `String` | `appsink`에서 뽑아낼 픽셀 포맷 | 기본값: `RGBA` (Flutter 최적화) |
| `maxQueueSize` | `int` | 파이프라인 내부 큐 사이즈 | 고해상도 스트리밍 시 메모리 제어용 |
| `enableAudio` | `bool` | 오디오 동시 재생 여부 | 비디오만 필요한 경우 `false` |

### 3. 소스 설정 파라미터 (`setSource`)

다양한 비디오 소스(HLS, RTSP, MP4) 대응을 위한 설정입니다.

* **`uri` (String)**: 미디어 소스 경로.
* **`sync` (bool)**: 실시간성 강조 여부. `false`일 경우(RTSP 등) AV Sync를 희생하더라도 지연시간(Latency)을 최소화합니다.
* **`customPipeline` (String?)**: (전문가용) 사용자가 직접 `uridecodebin` 뒤에 붙을 파이프라인 조각을 정의할 수 있게 합니다.

### 4. 핵심 파이프라인 구조 (Conceptual)

```text
// 내부 기본 파이프라인
uridecodebin uri=$uri name=src ! videoconvert ! video/x-raw,format=RGBA ! appsink name=video_sink

```

### 5. 핵심 API 및 이벤트 (Methods & Signals)

* **`getTextureId()`**: Flutter `Texture` 위젯에 전달할 고유 ID 반환.
* **`setSize(int width, int height)`**: 비디오 출력 크기 제한(Resize).
* **`onVideoResolutionChanged`**: 비디오 크기 정보가 확인되었을 때 발생하는 스트림.
* **`onFirstFrameRendered`**: 첫 프레임이 성공적으로 `appsink`에 도달했을 때 발생.

---

## 🛠️ 구현을 위한 기술적 로직 정의

비디오 중심 라이브러리 개발에서 가장 먼저 해결해야 할 **3대 과제**입니다.

1. **Dynamic Pad Linking**: `uridecodebin`에서 비디오 스트림이 감지되는 순간(pad-added), `videoconvert`와 `appsink`를 동적으로 연결하는 로직이 C++ 단에 구현되어야 합니다.
2. **Texture Registration**: `dart:ffi`를 통해 네이티브에서 만든 텍스처를 Flutter 엔진에 등록하고 그 ID를 Dart로 안전하게 넘겨줘야 합니다.
3. **Frame Callback**: `appsink`의 `new-sample` 시그널이 발생할 때마다, 메모리 포인터를 텍스처 버퍼로 복사하고 Flutter에게 "화면을 다시 그려라(markTextureFrameAvailable)"고 알려야 합니다.
