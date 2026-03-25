pub fn initialize() -> anyhow::Result<()> {
    gstreamer::init()?;
    Ok(())
}

pub struct Player {
    // 여기에 실제 GStreamer 파이프라인 구현이 들어갈 예정입니다.
}

impl Player {
    pub fn new() -> Self {
        Self {}
    }
}
