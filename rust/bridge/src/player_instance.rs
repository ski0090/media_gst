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
}

pub type SharedPlayerInstance = Arc<RwLock<PlayerInstance>>;

impl PlayerInstance {
    pub fn new() -> SharedPlayerInstance {
        Arc::new(RwLock::new(Self {
            id: Uuid::new_v4(),
            state: PlayerState::Stop,
        }))
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn set_state(&mut self, state: PlayerState) {
        self.state = state;
        log::info!("Player {} state changed to {:?}", self.id, self.state);
    }

    pub fn get_state(&self) -> PlayerState {
        self.state
    }
}
