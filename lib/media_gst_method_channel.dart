import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'media_gst_platform_interface.dart';

/// An implementation of [MediaGstPlatform] that uses method channels.
class MethodChannelMediaGst extends MediaGstPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('media_gst');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
