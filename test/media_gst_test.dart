import 'package:flutter_test/flutter_test.dart';
import 'package:media_gst/media_gst.dart';
import 'package:media_gst/media_gst_platform_interface.dart';
import 'package:media_gst/media_gst_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMediaGstPlatform
    with MockPlatformInterfaceMixin
    implements MediaGstPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MediaGstPlatform initialPlatform = MediaGstPlatform.instance;

  test('$MethodChannelMediaGst is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMediaGst>());
  });

  test('getPlatformVersion', () async {
    MediaGst mediaGstPlugin = MediaGst();
    MockMediaGstPlatform fakePlatform = MockMediaGstPlatform();
    MediaGstPlatform.instance = fakePlatform;

    expect(await mediaGstPlugin.getPlatformVersion(), '42');
  });
}
