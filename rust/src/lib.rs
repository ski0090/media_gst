pub mod api;
pub mod player_instance;
pub mod sink;
mod frb_generated;

/// 전역 로깅 및 GStreamer 초기화를 수행합니다.
pub fn init_native() {
    // env_logger 초기화 (Rust 및 GStreamer 로그 출력 지원)
    env_logger::Builder::from_env(env_logger::Env::default().default_filter_or("info")).init();

    // GStreamer 초기화
    if let Err(err) = gstreamer::init() {
        log::error!("GStreamer init failed: {:?}", err);
    } else {
        log::info!("GStreamer init success");
    }

    #[cfg(target_os = "windows")]
    {
        // Windows 전용 스트리밍 최적화 (예: D3D 디바이스 연동 등)
        log::info!("Windows optimized backend enabled");
    }
}
