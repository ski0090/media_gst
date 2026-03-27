use crate::player_instance::{PlayerEvent, PlayerInstance, PlayerState};
use flutter_rust_bridge::frb::StreamSink;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // lib.rs의 전역 초기화 로직을 실행합니다.
    crate::init_native();
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

pub fn create_player() -> PlayerInstance {
    PlayerInstance::new()
}

pub fn set_source(player: &mut PlayerInstance, uri: String) -> Result<(), String> {
    player.set_source(&uri).map_err(|e| e.to_string())
}

pub fn subscribe_player_events(player: &mut PlayerInstance, sink: StreamSink<PlayerEvent>) -> Result<(), String> {
    let mut rx = player.take_event_stream().ok_or_else(|| "Event stream already taken".to_string())?;

    tokio::spawn(async move {
        while let Some(event) = rx.recv().await {
            if let Err(e) = sink.add(event) {
                log::error!("Failed to send event to Flutter: {:?}", e);
                break;
            }
        }
    });

    Ok(())
}

pub fn play(player: &mut PlayerInstance) -> Result<(), String> {
    player.set_state(PlayerState::Play).map_err(|e| e.to_string())
}

pub fn pause(player: &mut PlayerInstance) -> Result<(), String> {
    player.set_state(PlayerState::Pause).map_err(|e| e.to_string())
}

pub fn stop(player: &mut PlayerInstance) -> Result<(), String> {
    player.set_state(PlayerState::Stop).map_err(|e| e.to_string())
}
