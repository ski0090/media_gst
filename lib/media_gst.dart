// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'media_gst_platform_interface.dart';
import 'src/rust/frb_generated.dart';
export 'src/rust/api.dart';
export 'src/rust/player_instance.dart';

class MediaGst {
  /// Initializes the GStreamer Rust backend.
  /// Must be called before using any media playback features.
  static Future<void> init() async {
    await RustLib.init();
  }

  Future<String?> getPlatformVersion() {
    return MediaGstPlatform.instance.getPlatformVersion();
  }
}
