import 'dart:async';
import 'package:flutter/material.dart';

import '../rust/api.dart';
import '../rust/player_instance.dart';

/// 컨트롤러: GStreamer 플레이어(PlayerInstance)의 상태와 동작을 관리합니다.
class GstPlayerController extends ChangeNotifier {
  PlayerInstance? _player;
  StreamSubscription<PlayerEvent>? _eventSubscription;

  PlayerState _state = PlayerState.stop;
  PlayerState get state => _state;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _bufferingPercent = 0;
  int get bufferingPercent => _bufferingPercent;

  /// 향후 ExternalTexture 지원 시 사용될 textureId
  int? get textureId => null;

  /// 플레이어를 생성하고 URI를 설정하여 초기화합니다.
  Future<void> initialize(String uri) async {
    try {
      _errorMessage = null;

      if (_eventSubscription != null) {
        await _eventSubscription!.cancel();
        _eventSubscription = null;
      }
      if (_player != null) {
        _player!.dispose();
        _player = null;
      }

      _player = await createPlayer();
      _eventSubscription = subscribePlayerEvents(
        player: _player!,
      ).listen(_onPlayerEvent);

      await setSource(player: _player!, uri: uri);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isInitialized = false;
      notifyListeners();
    }
  }

  void _onPlayerEvent(PlayerEvent event) {
    event.when(
      stateChanged: (newState) {
        _state = newState;
        notifyListeners();
      },
      error: (err) {
        _errorMessage = err;
        notifyListeners();
      },
      endOfStream: () {
        _state = PlayerState.stop;
        notifyListeners();
      },
      buffering: (percent) {
        _bufferingPercent = percent;
        notifyListeners();
      },
      clockLost: () {
        debugPrint('MediaGst: Clock Lost');
      },
    );
  }

  /// 재생 시작
  Future<void> playStream() async {
    if (_player != null) {
      await play(player: _player!);
    }
  }

  /// 재생 일시정지
  Future<void> pauseStream() async {
    if (_player != null) {
      await pause(player: _player!);
    }
  }

  /// 재생 정지
  Future<void> stopStream() async {
    if (_player != null) {
      await stop(player: _player!);
    }
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    if (_player != null) {
      stop(player: _player!).ignore();
      _player?.dispose();
      _player = null;
    }
    super.dispose();
  }
}

/// GStreamer 비디오 플레이어를 렌더링하는 위젯
class GstPlayer extends StatelessWidget {
  final GstPlayerController controller;

  const GstPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.errorMessage != null) {
          return Center(
            child: Text(
              'Error: ${controller.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!controller.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        Widget videoLayer;
        if (controller.textureId != null) {
          videoLayer = Texture(textureId: controller.textureId!);
        } else {
          videoLayer = Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                '오디오 전용 또는 외부 윈도우 렌더링 중',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Stack(
          children: [
            videoLayer,
            if (controller.bufferingPercent > 0 && controller.bufferingPercent < 100)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(
                      'Buffering ${controller.bufferingPercent}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
