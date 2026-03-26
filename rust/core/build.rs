use std::env;

fn main() {
    // 1. Windows 환경 GStreamer SDK 링킹 설정
    // [ENV.md 5. 트러블슈팅 / AGENTS.md 3. Zero-Copy 구현 검증]
    // 타겟 OS가 Windows인 경우, 설치된 GStreamer SDK의 라이브러리 경로를 검색하여 링크합니다.
    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap_or_default();
    if target_os == "windows" {
        // Windows GStreamer SDK 기본 설치 경로 환경 변수 확인 (MSVC 64-bit)
        if let Ok(gst_root) = env::var("GSTREAMER_1_0_ROOT_MSVC_X86_64") {
            println!("cargo:rustc-link-search=native={}\\lib", gst_root);
            
            // GStreamer 핵심 및 미디어 처리를 위한 주요 라이브러리 링킹
            println!("cargo:rustc-link-lib=gstreamer-1.0");
            println!("cargo:rustc-link-lib=gstvideo-1.0");
            println!("cargo:rustc-link-lib=gstapp-1.0");
            println!("cargo:rustc-link-lib=gobject-2.0");
            println!("cargo:rustc-link-lib=glib-2.0");
            
            println!("cargo:info=GStreamer SDK linked from: {}", gst_root);
        } else {
            // SDK가 없더라도 빌드 훅(build.dart)에서 처리될 수 있으므로 경고만 출력
            println!("cargo:warning=GStreamer SDK (MSVC x86_64) not found. Please install GStreamer and set GSTREAMER_1_0_ROOT_MSVC_X86_64.");
        }
    }

    // GStreamer 설치 경로 환경 변수 변경 시 빌드 스크립트를 재실행하도록 지시합니다.
    println!("cargo:rerun-if-env-changed=GSTREAMER_1_0_ROOT_MSVC_X86_64");
}
