# ENV.md: 현대적 네이티브 통합 및 개발 환경 가이드

[cite_start]본 프로젝트는 Rust 코어와 Flutter UI를 결합하며, **Dart 빌드 훅(Build Hooks)**을 통해 네이티브 바이너리의 다운로드, 컴파일, 링킹을 자동화합니다[cite: 1].

## 1. 필수 도구 설치
프로젝트 빌드를 위해 다음 도구들이 로컬 환경에 설치되어 있어야 합니다.

* [cite_start]**Flutter SDK**: v3.10 이상 (Native Assets 기능 지원 버전) [cite: 1]
* [cite_start]**Rust Toolchain**: `rustup`을 통해 설치된 최신 Stable 버전 [cite: 1]
* [cite_start]**LLVM / Clang**: C ABI 바인딩 생성을 위해 필요 [cite: 1]
* **GStreamer SDK**: 
    * **Android/iOS**: 빌드 훅이 원격 바이너리를 수급하여 자동화.
    * **Desktop**: 시스템 패키지(`libgstreamer1.0-dev`) 필요.
    * **참고**: Rust 레이어를 `bridge`와 `core`로 분리하여 **Dart 바인딩 생성(`generate`) 단계에서는 GStreamer SDK 없이도 동작**하도록 최적화되었습니다.

## 2. 네이티브 에셋 자동화 구조 (Native Assets)
[cite_start]본 프로젝트는 플랫폼별 빌드 스크립트(Gradle, Podspec)에 의존하는 대신, `hook/build.dart`를 통해 네이티브 의존성을 관리합니다[cite: 1].

* [cite_start]**동적 수급**: 빌드 시점에 타겟 아키텍처(arm64, x86_64 등)를 감지하여 최적화된 바이너리를 원격 서버에서 자동으로 다운로드합니다[cite: 1].
* **무결성 검증**: 공급망 보안을 위해 모든 바이너리는 다운로드 직후 **SHA-256 해시 검증**을 거칩니다. [cite_start]해시가 일치하지 않으면 빌드 파이프라인이 즉시 중단됩니다[cite: 1].
* [cite_start]**자동 링킹**: `@Native()` 어노테이션을 통해 런타임에 별도의 경로 설정 없이 네이티브 함수를 호출합니다[cite: 1].

## 3. 프로젝트 초기화 및 빌드 절차

1.  **의존성 수급**:
    ```bash
    flutter pub get
    ```
2.  **Dart ↔ Rust 바인딩 생성 (GStreamer SDK 불필요)**:
    ```bash
    # flutter_rust_bridge_codegen이 사전 설치되어 있어야 함 (cargo install)
    flutter_rust_bridge_codegen generate
    ```
3.  **애플리케이션 빌드 및 실행 (GStreamer SDK 필요)**:
    `flutter run` 실행 시 `hook/build.dart`가 가동되어 Rust 코드를 빌드하고 링킹합니다.
    ```bash
    flutter run
    ```
    *참고: 필요시 `native_toolchain_rust`가 자동으로 작동하여 최신 Rust 코드를 컴파일합니다.*

## 4. 환경 변수 및 보안 주의사항
* [cite_start]**네이티브 추출**: Android의 경우, FFI의 안정적인 접근을 위해 `AndroidManifest.xml`에 `android:extractNativeLibs="true"` 설정이 필요할 수 있습니다[cite: 1].
* [cite_start]**Apple 공증**: iOS/macOS 배포 시, 원격에서 수급하는 바이너리는 반드시 Apple Developer ID로 코드 서명(`codesign`)이 완료된 상태여야 합니다[cite: 1].
* **프록시 설정**: 회사 내부망 등 폐쇄적인 네트워크 환경에서는 빌드 훅이 바이너리를 다운로드할 수 있도록 환경 변수에 HTTP 프록시 설정을 확인하십시오.

## 5. 트러블슈팅
* **Hash Mismatch**: 다운로드된 바이너리가 오염되었거나 버전이 맞지 않는 경우 발생합니다. [cite_start]빌드 캐시를 삭제하고 다시 시도하십시오[cite: 1].
* [cite_start]**Architecture Unsupported**: 타겟 기기의 CPU 아키텍처에 맞는 바이너리가 원격 서버에 없는 경우 발생합니다[cite: 1]. `SPEC.md`의 지원 아키텍처 목록을 확인하십시오.