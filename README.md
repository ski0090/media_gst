<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

이 패키지는 Rust와 FFI를 통해 C/C++ 기반의 GStreamer 커널을 제어합니다.  
따라서 앱을 컴파일하고 실행하려면 **개발 환경 운영체제에 맞는 GStreamer SDK 설치가 필수적입니다.**

### 패키지 사용 사전 준비 (Prerequisites)

1. **GStreamer MSVC SDK 다운로드** (Windows 개발 환경 기준)
   * 최신 버전(1.28+)부터는 런타임과 개발용(SDK) 패키지가 하나로 통합되었습니다.
   * [GStreamer 공식 다운로드 페이지](https://gstreamer.freedesktop.org/download/)에서 타겟 환경에 맞는 **MSVC x86_64** 인스톨러 파일(`.msi`) 1개만 다운로드하여 설치하시면 됩니다.
   * 설치 시 'Complete(전체 설치)' 유형을 선택하시길 권장합니다. (기본 설치 경로: `C:\gstreamer\1.0\msvc_x86_64` 또는 `C:\Program Files\gstreamer\1.0\msvc_x86_64`)
2. **Rust 툴체인 설치**
   * 패키지 빌드를 위해 [rustup](https://rustup.rs/) 이 설치되어 있어야 합니다.
3. **로컬 환경 설정 파일 구성 (.cargo/config.toml)**
   * `rust/.cargo/config.toml.example` 파일을 복사하거나 이름을 `config.toml`로 변경하여 생성합니다.
   * 복사된 파일 내부의 `PKG_CONFIG_PATH`와 `GSTREAMER_1_0_ROOT_MSVC_X86_64`가 본인 PC의 실제 GStreamer 설치 경로와 일치하는지 확인합니다.
   * (*참고: `.cargo/config.toml`은 `.gitignore`에 등록되어 버전 관리에서 제외되므로 개발자 환경에 맞게 자유롭게 수정 가능합니다.*)
4. 시스템 설정이 완료된 후, Dart/Flutter 빌드 시스템(`build.dart`)이 코어 라이브러리를 통해 파이프라인 컴파일을 수행할 수 있게 됩니다.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
