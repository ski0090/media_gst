import 'dart:async';

/// 비디오 해상도 정보를 담는 클래스
class VideoResolution {
  final int width;
  final int height;

  VideoResolution(this.width, this.height);

  @override
  String toString() => 'VideoResolution(${width}x$height)';
}

/// GStreamer 파이프라인을 제어하고 Flutter Texture와 연동하는 핵심 클래스
class GstVideoPlayer {
  final bool useHardwareAcceleration;
  final String pixelFormat;
  final int maxQueueSize;
  final bool enableAudio;

  final StreamController<VideoResolution> _resolutionController =
      StreamController<VideoResolution>.broadcast();
  final StreamController<void> _firstFrameController =
      StreamController<void>.broadcast();

  /// 비디오 크기 정보가 확인되었을 때 발생하는 스트림
  Stream<VideoResolution> get onVideoResolutionChanged =>
      _resolutionController.stream;

  /// 첫 프레임이 성공적으로 렌더링되었을 때 발생하는 스트림
  Stream<void> get onFirstFrameRendered => _firstFrameController.stream;

  GstVideoPlayer({
    this.useHardwareAcceleration = true,
    this.pixelFormat = 'RGBA',
    this.maxQueueSize = 100,
    this.enableAudio = true,
  });

  /// Flutter [Texture] 위젯에 전달할 고유 ID 반환
  Future<int> getTextureId() async {
    // TODO: 네이티브 브릿지를 통한 텍스처 등록 및 ID 반환 구현
    return -1;
  }

  /// 미디어 소스를 설정하고 파이프라인을 시작
  Future<void> setSource(
    String uri, {
    bool sync = true,
    String? customPipeline,
  }) async {
    // TODO: GStreamer 파이프라인 구성 및 소스 설정 구현
  }

  /// 비디오 출력 크기 제한(Resize)
  void setSize(int width, int height) {
    // TODO: 네이티브 레이어에 크기 변경 요청 전달
  }

  /// 자원 해제
  Future<void> dispose() async {
    await _resolutionController.close();
    await _firstFrameController.close();
  }
}
