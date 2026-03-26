use gstreamer::prelude::*;

pub fn initialize() -> anyhow::Result<()> {
    gstreamer::init()?;
    Ok(())
}

pub struct Player {
    pipeline: Option<gstreamer::Pipeline>,
}

impl Player {
    pub fn new() -> Self {
        Self { pipeline: None }
    }

    pub fn set_source(
        &mut self,
        uri: String,
        _is_sync: bool,
        custom_pipeline: Option<String>,
    ) -> anyhow::Result<()> {
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
        log::info!("Source set to: {}", uri);
        Ok(())
    }
}
