use flutter_rust_bridge::frb;

pub struct GstPlayerConfig {
    pub use_hardware_acceleration: bool,
    pub pixel_format: String,
    pub max_queue_size: i32,
    pub enable_audio: bool,
}

pub struct GstVideoPlayer {
    // 내부적으로 GStreamer 파이프라인이나 상태를 관리할 구조체
    // 실제 구현에서는 Arc<Mutex<...>> 등을 사용하여 안전하게 관리해야 함
}

impl GstVideoPlayer {
    #[frb(sync)]
    pub fn new(config: GstPlayerConfig) -> Self {
        // TODO: GStreamer 초기화 및 파이프라인 준비
        Self {}
    }

    pub fn set_source(&self, uri: String, sync: bool, custom_pipeline: Option<String>) {
        // TODO: uridecodebin 설정 및 파이프라인 시작
    }

    pub fn get_texture_id(&self) -> i64 {
        // TODO: Flutter Texture ID 반환 로직
        0
    }

    pub fn set_size(&self, width: i32, height: i32) {
        // TODO: 비디오 크기 조정 로직
    }
}

// Global initialization
/// GStreamer 런타임을 초기화합니다.
/// 실제 구현은 core 라이브러리(media_gst_core)에서 처리됩니다.
pub fn init_gstreamer() {
    #[cfg(feature = "gst")]
    {
        // core 라이브러리의 초기화 함수 호출
        if let Err(e) = media_gst_core::initialize() {
            log::error!("Failed to initialize GStreamer: {:?}", e);
        }
    }
}
