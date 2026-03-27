import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'media_gst_method_channel.dart';

abstract class MediaGstPlatform extends PlatformInterface {
  /// Constructs a MediaGstPlatform.
  MediaGstPlatform() : super(token: _token);

  static final Object _token = Object();

  static MediaGstPlatform _instance = MethodChannelMediaGst();

  /// The default instance of [MediaGstPlatform] to use.
  ///
  /// Defaults to [MethodChannelMediaGst].
  static MediaGstPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MediaGstPlatform] when
  /// they register themselves.
  static set instance(MediaGstPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
