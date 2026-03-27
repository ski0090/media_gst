use parking_lot::RwLock;
use std::sync::Arc;
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlayerState {
    Play,
    Pause,
    Stop,
}

pub struct PlayerInstance {
    id: Uuid,
    state: PlayerState,
    core_player: crate::media_core::Player,
}

pub type SharedPlayerInstance = Arc<RwLock<PlayerInstance>>;

impl PlayerInstance {
    pub fn new(config: crate::media_core::GstPlayerConfig) -> SharedPlayerInstance {
        Arc::new(RwLock::new(Self {
            id: Uuid::new_v4(),
            state: PlayerState::Stop,
            core_player: crate::media_core::Player::new(config),
        }))
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn set_source(&mut self, uri: String, is_sync: bool, custom_pipeline: Option<String>) {
        if let Err(e) = self.core_player.set_source(uri, is_sync, custom_pipeline) {
            log::error!("Failed to set source for player {}: {:?}", self.id, e);
        }
    }

    pub fn set_state(&mut self, state: PlayerState) {
        self.state = state;
        log::info!("Player {} state changed to {:?}", self.id, self.state);
    }

    pub fn get_state(&self) -> PlayerState {
        self.state
    }
}
