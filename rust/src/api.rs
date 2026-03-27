#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // GStreamer 초기화
    gstreamer::init().expect("Failed to initialize GStreamer");
    
    #[cfg(target_os = "windows")]
    {
        // Windows 전용 스트리밍 모범 사례 초기화 (예: D3D 디바이스 등)
    }
}

pub fn hello_from_rust() -> String {
    #[cfg(target_os = "windows")]
    let platform = "Windows with GStreamer SDK Support";
    
    #[cfg(target_os = "linux")]
    let platform = "Linux with Native GStreamer Support";
    
    #[cfg(not(any(target_os = "windows", target_os = "linux")))]
    let platform = "Other platform";

    format!("Hello from Rust on {}!", platform)
}

// GStreamer 싱크 설정 예시 (실제 구현 시 활용)
pub fn get_video_sink() -> String {
    #[cfg(target_os = "windows")]
    return "d3d11videosink".to_string(); // Zero-copy 대응용 Windows 최적화 싱크
    
    #[cfg(target_os = "linux")]
    return "gtksink".to_string();
    
    #[cfg(not(any(target_os = "windows", target_os = "linux")))]
    return "autovideosink".to_string();
}
