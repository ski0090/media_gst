use gst::prelude::*;
use gstreamer as gst;
use tokio::sync::mpsc;
use uuid::Uuid;

#[derive(Debug, Clone)]
pub enum PlayerEvent {
    StateChanged(PlayerState),
    Error(String),
    EndOfStream,
    Buffering(i32),
    ClockLost,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlayerState {
    Play,
    Pause,
    Stop,
}

pub struct PlayerInstance {
    pub id: Uuid,
    state: PlayerState,
    pipeline: Option<gst::Pipeline>,
    event_tx: mpsc::UnboundedSender<PlayerEvent>,
    event_rx: Option<mpsc::UnboundedReceiver<PlayerEvent>>,
}

// FRB v2에서 RustOpaque(또는 자동 Opaque)로 처리되도록 하기 위해 Arc 없이 정의할 수도 있으나,
// 다중 스레드 접근을 위해 Arc<parking_lot::RwLock>을 사용하는 것이 좋습니다.
// 하지만 여기서는 간단하게 구조체 자체를 반환하고 FRB의 자동 Wrapper를 활용하겠습니다.

impl PlayerInstance {
    pub fn new() -> Self {
        let id = Uuid::new_v4();
        let (tx, rx) = mpsc::unbounded_channel();
        Self {
            id,
            state: PlayerState::Stop,
            pipeline: None,
            event_tx: tx,
            event_rx: Some(rx),
        }
    }

    pub fn take_event_stream(&mut self) -> Option<mpsc::UnboundedReceiver<PlayerEvent>> {
        self.event_rx.take()
    }

    pub fn id(&self) -> Uuid {
        self.id
    }

    pub fn set_state(&mut self, state: PlayerState) -> anyhow::Result<()> {
        log::info!("Player {} state changing to {:?}", self.id, state);

        if let Some(pipeline) = &self.pipeline {
            let gst_state = match state {
                PlayerState::Play => gst::State::Playing,
                PlayerState::Pause => gst::State::Paused,
                PlayerState::Stop => gst::State::Null,
            };
            pipeline.set_state(gst_state)?;
        }

        self.state = state;
        let _ = self.event_tx.send(PlayerEvent::StateChanged(state));
        Ok(())
    }

    pub fn get_state(&self) -> PlayerState {
        self.state
    }

    pub fn set_source(&mut self, uri: &str) -> anyhow::Result<()> {
        let uri = uri.trim();
        log::info!("Player {} setting source to '{}'", self.id, uri);

        // 이전 파이프라인이 있으면 정지 및 제거
        if let Some(pipeline) = self.pipeline.take() {
            pipeline.set_state(gst::State::Null)?;
        }

        // uridecodebin3 기반 파이프라인 생성
        let pipeline = gst::Pipeline::new();
        let source = gst::ElementFactory::make("uridecodebin3")
            .property("uri", uri)
            .build()
            .map_err(|e| anyhow::anyhow!("Failed to create uridecodebin3: {}", e))?;

        // 싱크 생성 (플랫폼별 조건부 컴파일 적용)
        let sink = crate::sink::create_video_sink()?;

        pipeline.add_many([&source, &sink])?;

        // pad-added 시그널 처리 (uridecodebin3에서 영상 패드가 나오면 싱크의 입력 패드에 연결)
        let sink_clone = sink.clone();
        source.connect_pad_added(move |_src, src_pad| {
            let sink_pad = sink_clone.static_pad("sink").expect("Sink has no pad");
            if sink_pad.is_linked() {
                return;
            }

            let new_pad_caps = match src_pad.current_caps() {
                Some(caps) => caps,
                None => {
                    log::warn!("Pad {} has no caps yet. Cannot link.", src_pad.name());
                    return;
                }
            };
            
            let new_pad_struct = match new_pad_caps.structure(0) {
                Some(s) => s,
                None => {
                    log::warn!("Caps have no structure");
                    return;
                }
            };
            let new_pad_type = new_pad_struct.name();

            // 비디오 스트림인 경우에만 연결
            if new_pad_type.starts_with("video/") {
                if let Err(err) = src_pad.link(&sink_pad) {
                    log::error!("Failed to link pads: {}", err);
                } else {
                    log::info!("Linked video pad forward to sink");
                }
            }
        });

        // Bus 메시지 처리
        let bus = pipeline.bus().expect("Pipeline has no bus");
        let event_tx_clone = self.event_tx.clone();

        let _ = bus
            .add_watch(move |_bus, msg| {
                use gst::MessageView;
                match msg.view() {
                    MessageView::Error(err) => {
                        let error_msg = format!(
                            "GStreamer error: {} ({})",
                            err.error(),
                            err.debug().unwrap_or_default()
                        );
                        log::error!("{}", error_msg);
                        let _ = event_tx_clone.send(PlayerEvent::Error(error_msg));
                    }
                    MessageView::Eos(_eos) => {
                        log::info!("End of stream reached");
                        let _ = event_tx_clone.send(PlayerEvent::EndOfStream);
                    }
                    MessageView::Buffering(buffering) => {
                        let percent = buffering.percent();
                        log::info!("Buffering: {}%", percent);
                        let _ = event_tx_clone.send(PlayerEvent::Buffering(percent));
                    }
                    MessageView::ClockLost(_clock_lost) => {
                        log::warn!("Clock lost");
                        let _ = event_tx_clone.send(PlayerEvent::ClockLost);
                    }
                    _ => (),
                }
                gst::glib::ControlFlow::Continue
            })
            .map_err(|e| anyhow::anyhow!("Failed to add bus watch: {}", e))?;

        self.pipeline = Some(pipeline);
        Ok(())
    }
}
