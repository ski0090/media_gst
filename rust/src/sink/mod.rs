#[cfg(target_os = "windows")]
pub mod windows;
#[cfg(target_os = "windows")]
pub use windows::create_video_sink;

#[cfg(target_os = "android")]
pub mod android;
#[cfg(target_os = "android")]
pub use android::create_video_sink;

#[cfg(not(any(target_os = "windows", target_os = "android")))]
pub fn create_video_sink() -> anyhow::Result<gstreamer::Element> {
    gstreamer::ElementFactory::make("autovideosink")
        .build()
        .map_err(|e| anyhow::anyhow!("Failed to create sink autovideosink: {}", e))
}
