pub mod api;
mod frb_generated; /* 자동 생성될 파일 */

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
    
    // env_logger 초기화 (Rust 및 GStreamer 로그 연동)
    let _ = env_logger::try_init();

    log::info!("Rust logger initialized.");

    // GStreamer 초기화 연동
    api::init_gstreamer();
}
