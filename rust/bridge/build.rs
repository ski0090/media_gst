use std::env;

fn main() {
    // 1. Flutter Rust Bridge Codegen 자동화
    // flutter_rust_bridge.yaml 설정 파일을 참조하여 Dart/Rust 바인딩을 자동으로 생성합니다.
    // [SPEC.md 1. 아키텍처 개요 / ENV.md 3. 프로젝트 초기화]
    if env::var("CARGO_FEATURE_CODEGEN").is_ok() {
        // lib_flutter_rust_bridge_codegen::codegen::generate() 호출을 통해
        // bridge/src/api.rs로부터 frb_generated.rs 및 Dart 코드를 생성합니다.
        if let Err(e) = lib_flutter_rust_bridge_codegen::codegen::generate(Default::default(), Default::default()) {
            eprintln!("Error during flutter_rust_bridge_codegen::generate: {:?}", e);
            // 빌드 중단이 필요한 경우 panic! 또는 exit(1) 고려 가능
        }
    }

    // 3. 빌드 트리거 설정
    // API 정의 또는 설정 파일이 변경되면 다시 컴파일하도록 지시합니다.
    println!("cargo:rerun-if-changed=src/api.rs");
    println!("cargo:rerun-if-changed=../../flutter_rust_bridge.yaml");
}
