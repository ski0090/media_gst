use gstreamer::prelude::*;

pub fn initialize() -> anyhow::Result<()> {
    gstreamer::init()?;
    Ok(())
}

pub struct GstPlayerConfig {
    pub use_hardware_acceleration: bool,
    pub pixel_format: String,
    pub max_queue_size: i32,
    pub enable_audio: bool,
}

pub struct Player {
    pipeline: Option<gstreamer::Pipeline>,
    config: GstPlayerConfig,
}

impl Player {
    pub fn new(config: GstPlayerConfig) -> Self {
        Self {
            pipeline: None,
            config,
        }
    }

    pub fn set_source(
        &mut self,
        uri: String,
        _is_sync: bool,
        custom_pipeline: Option<String>,
    ) -> anyhow::Result<()> {
        // 기존 파이프라인이 있다면 중지 및 정리
        if let Some(old_pipeline) = self.pipeline.take() {
            let _ = old_pipeline.set_state(gstreamer::State::Null);
            log::info!("Previous pipeline stopped and released.");
        }

        if let Some(pipeline_str) = custom_pipeline {
            let pipeline = gstreamer::parse::launch(&pipeline_str)?
                .dynamic_cast::<gstreamer::Pipeline>()
                .map_err(|_| anyhow::anyhow!("Failed to cast to Pipeline"))?;
            self.pipeline = Some(pipeline);
        } else {
            let pipeline = gstreamer::Pipeline::new();
            let src = gstreamer::ElementFactory::make("uridecodebin")
                .name("src")
                .property("uri", &uri)
                .build()
                .map_err(|_| anyhow::anyhow!("Failed to create uridecodebin"))?;

            pipeline.add(&src)?;
            self.pipeline = Some(pipeline);
        }

        if let Some(pipeline) = &self.pipeline {
            pipeline.set_state(gstreamer::State::Playing)?;
        }

        log::info!("Source set and playing: {}", uri);
        Ok(())
    }
}
