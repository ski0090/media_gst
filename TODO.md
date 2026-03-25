# media_gst — 커밋 단위 작업 목록

> 기준 문서: [SPEC.md](./SPEC.md) · [ENV.md](./ENV.md) · [AGENTS.md](./AGENTS.md)

---

## Phase 1 — 프로젝트 기반 정비

- [ ] `chore: flutter_rust_bridge 코드 생성 파이프라인 구성`
  - `hook/build.dart` 생성
  - `pubspec.yaml`에 `native_toolchain_rust` 추가
  - `flutter_rust_bridge_codegen` 초기화

- [ ] `chore: Rust Cargo.toml 크레이트 의존성 버전 고정`
  - `tokio`, `uuid`, `anyhow` 버전 명시
  - feature flag (`tokio/full`) 추가
  - `[build-dependencies]`에 `flutter_rust_bridge` 추가

- [ ] `feat(rust): build.rs 생성 — FRB 코드 생성 및 GStreamer 링크 설정`
  - `rust/build.rs` 신규
  - `flutter_rust_bridge::codegen::generate()` 호출로 Dart 바인딩 자동 생성
  - Windows: `cargo:rustc-link-search` / `rustc-link-lib`로 GStreamer SDK 경로 명시
  - 플랫폼별 `#[cfg]` 분기 처리

- [ ] `docs: pubspec.yaml 패키지 설명 및 메타데이터 보완`
  - `description`, `homepage`, `repository` 등 공개 정보 기입

---

## Phase 2 — Rust 코어: GStreamer 초기화 및 파이프라인

- [ ] `feat(rust): GStreamer 초기화 및 로깅 설정`
  - `lib.rs` — `gst::init()`, `env_logger` 연동

- [ ] `feat(rust): PlayerInstance 구조체 정의 (UUID, 상태 열거형)`
  - `player_instance.rs` 신규
  - `PlayerState(Play/Pause/Stop)`, `Arc<Mutex<>>` 래핑

- [ ] `feat(rust): uridecodebin 기반 GStreamer 파이프라인 생성`
  - `api.rs` — `set_source()` 구현
  - SPEC §2.1 RTSP/HLS/MP4 파이프라인 구성

- [ ] `feat(rust): tokio broadcast 채널로 전체 채널 상태 동기화`
  - `channel_manager.rs` 신규
  - SPEC §3.1 다채널 관리

- [ ] `feat(rust): 플랫폼별 조건부 컴파일로 비디오 Sink 분기`
  - `sink/mod.rs`, `sink/windows.rs`, `sink/android.rs`
  - `#[cfg(target_os = "...")]` 활용 (AGENTS.md §2)

---

## Phase 3 — Zero-Copy 텍스처 연동 (SPEC §3.2)

> ⚠️ 픽셀 데이터를 `Uint8List`로 복사하는 로직 금지 (AGENTS.md §3)

- [ ] `feat(rust/android): glimagesink → SurfaceTexture 바인딩`
  - `sink/android.rs` — GPU 텍스처 핸들 생성, JNI 연동

- [ ] `feat(rust/windows): appsink 공유 메모리 처리 구현`
  - `sink/windows.rs` — `gst-app` appsink 콜백, 공유 메모리 참조

- [ ] `feat(rust): get_texture_id() — Flutter ExternalTexture ID 반환`
  - `api.rs` — 텍스처 핸들 ID를 `i64`로 Dart 전달 (Zero-Copy 검증)

---

## Phase 4 — flutter_rust_bridge FFI 바인딩 생성

- [ ] `feat(dart): frb 코드 생성 결과물 커밋 (bridge 초기)`
  - `lib/src/rust/` 자동 생성 파일
  - `frb_generated.dart`, `frb_generated.io.dart`

- [ ] `feat(dart): GstVideoPlayer.getTextureId() 네이티브 브릿지 연결`
  - `gst_video_player.dart` — `TODO` 제거, FFI 호출로 교체

- [ ] `feat(dart): GstVideoPlayer.setSource() 네이티브 브릿지 연결`
  - `gst_video_player.dart` — `set_source` async FFI 연결

- [ ] `feat(dart): GstVideoPlayer.setSize() 네이티브 브릿지 연결`
  - `gst_video_player.dart` — `set_size` FFI 연결

---

## Phase 5 — Flutter UI: VideoPlayer 위젯

- [ ] `feat(dart): GstVideoWidget — Texture 위젯 래퍼 구현`
  - `lib/src/gst_video_widget.dart` 신규
  - `Texture(textureId: ...)` 위젯 생성

- [ ] `feat(dart): onVideoResolutionChanged 스트림 → UI 반영`
  - `gst_video_widget.dart` — AspectRatio 동적 업데이트

- [ ] `feat(dart): onFirstFrameRendered 스트림 → 로딩 스피너 제거`
  - `gst_video_widget.dart` — 첫 프레임 수신 시 placeholder 교체

---

## Phase 6 — 다채널 관리 API

- [ ] `feat(rust): ChannelManager — PlayerInstance CRUD`
  - `channel_manager.rs` — `HashMap<Uuid, PlayerInstance>`, create/destroy

- [ ] `feat(dart): MediaGst 파사드 — 채널 생성/제거 API`
  - `lib/media_gst.dart` — `createChannel()`, `destroyChannel()`

- [ ] `feat(dart): 전체 채널 일괄 제어 (Play/Pause/Stop All)`
  - `media_gst.dart` — broadcast 채널 활용

---

## Phase 7 — 빌드 훅 및 네이티브 에셋 자동화 (ENV.md §2)

- [ ] `feat(hook): hook/build.dart — 타겟 아키텍처 감지 및 바이너리 다운로드`
  - `hook/build.dart` 신규 (ENV.md §2 동적 수급 구현)

- [ ] `feat(hook): SHA-256 해시 검증 로직 추가`
  - `hook/build.dart` — 무결성 검증, 불일치 시 빌드 중단

- [ ] `feat(hook): Android extractNativeLibs 설정 가이드 및 자동화`
  - `example/android/app/src/main/AndroidManifest.xml` 수정

---

## Phase 8 — 예제 앱 및 테스트

- [ ] `feat(example): RTSP 단일 채널 재생 예제`
  - `example/` — RTSP URL 입력 → `GstVideoWidget` 출력

- [ ] `feat(example): 다채널(4분할) 동시 재생 예제`
  - `example/` — 2×2 Grid 배치, 각 채널 독립 PlayerInstance

- [ ] `test: GstVideoPlayer 단위 테스트 (mock 브릿지)`
  - `test/gst_video_player_test.dart`

- [ ] `test: ChannelManager Rust 유닛 테스트`
  - `rust/src/channel_manager.rs` `#[cfg(test)]` 블록

---

## Phase 9 — 품질 및 릴리스

- [ ] `ci: GitHub Actions 빌드 매트릭스 (Android/Windows)`
  - `.github/workflows/build.yml` 신규

- [ ] `docs: README.md — 설치, 빌드, API 사용법 작성`
  - `README.md` 전면 보강

- [ ] `chore: CHANGELOG.md v0.1.0 항목 작성 및 태그`
  - `CHANGELOG.md`
