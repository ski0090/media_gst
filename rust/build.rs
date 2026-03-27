use std::env;

fn main() -> anyhow::Result<()> {
    // 1. GStreamer Windows linking logic
    #[cfg(target_os = "windows")]
    {
        // GStreamer SDK의 기본 경로는 환경 변수에서 가져오거나 수동 지정합니다.
        // README.md의 가이드라인에 따라 여러 가능한 설치 경로를 확인합니다.
        let gst_root = env::var("GSTREAMER_1_0_ROOT_MSVC_X86_64").unwrap_or_else(|_| {
            let p1 = "C:\\gstreamer\\1.0\\msvc_x86_64";
            let p2 = "C:\\Program Files\\gstreamer\\1.0\\msvc_x86_64";
            if std::path::Path::new(p1).exists() {
                p1.to_string()
            } else {
                p2.to_string()
            }
        });

        let gst_lib_path = format!("{}\\lib", gst_root);

        // Cargo에 링커 검색 경로와 라이브러리를 알립니다.
        println!("cargo:rustc-link-search=native={}", gst_lib_path);
        println!("cargo:rustc-link-lib=gstreamer-1.0");
        println!("cargo:rustc-link-lib=gstvideo-1.0");
        println!("cargo:rustc-link-lib=gstapp-1.0");

        // SDK의 bin 폴더가 PATH에 있어야 런타임에 DLL을 찾을 수 있습니다.
        println!(
            "cargo:rustc-env=PATH={};{}",
            format!("{}\\bin", gst_root),
            env::var("PATH").unwrap_or_default()
        );
    }

    // 2. Flutter Rust Bridge (FRB) 바인딩 자동 생성
    // FRB v2에서는 flutter_rust_bridge_codegen::codegen::generate()를 호출합니다.
    // 빌드 시점에 코드를 생성하여 lib/src/rust/frb_generated.dart 등을 자동 업데이트합니다.

    // 무한 루프 방지를 위해 환경 변수 체크 (codegen이 다시 cargo build를 부를 수 있음)
    if env::var("FRB_SKIP_CODEGEN").is_err() {
        use anyhow::Context;
        use lib_flutter_rust_bridge_codegen::{codegen, codegen::Config};

        // 설정 파일 로드 (상위 디렉토리에 위치)
        let config = Config::from_config_file("../flutter_rust_bridge.yaml")
            .context("Failed to find or parse ../flutter_rust_bridge.yaml")?;
        
        let config = config.context("Config file not found at the specified path")?;

        // 바인딩 생성 실행
        codegen::generate(config, Default::default())
            .map_err(|e| anyhow::anyhow!("FRB generation failed: {}", e))?;
    }

    println!("cargo:rerun-if-changed=src/api.rs");
    println!("cargo:rerun-if-changed=../flutter_rust_bridge.yaml");

    Ok(())
}
