use gstreamer as gst;

pub fn create_video_sink() -> anyhow::Result<gst::Element> {
    // SPEC.md 2.2 비디오 출력 구성 
    // Windows/Linux: appsrc / appsink를 통한 공유 메모리 처리.
    // 현재는 구조 분리를 목적으로 기본 d3d11videosink 또는 appsink를 반환합니다. 
    // TODO: Zero-Copy 처리를 위해 appsink의 sample 콜백 및 공유 메모리 연동 구현
    let sink_name = "appsink"; 
    gst::ElementFactory::make(sink_name)
        .build()
        .map_err(|e| anyhow::anyhow!("Failed to create sink {}: {}", sink_name, e))
}
