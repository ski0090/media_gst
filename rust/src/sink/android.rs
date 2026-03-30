use gstreamer as gst;

pub fn create_video_sink() -> anyhow::Result<gst::Element> {
    // SPEC.md 2.2 비디오 출력 구성 
    // Android: glimagesink를 사용하여 SurfaceTexture에 직접 바인딩
    let sink_name = "glimagesink"; 
    gst::ElementFactory::make(sink_name)
        .build()
        .map_err(|e| anyhow::anyhow!("Failed to create sink {}: {}", sink_name, e))
}
