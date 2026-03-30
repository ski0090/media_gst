import 'dart:io';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final rustBuilder = RustBuilder(
      assetName: 'media_gst', // asset_id for Native Assets
      cratePath: 'rust',
      extraCargoEnvironmentVariables: {
        'GSTREAMER_1_0_ROOT_MSVC_X86_64': 'C:/Program Files/gstreamer/1.0/msvc_x86_64',
        'PATH': 'C:/Program Files/gstreamer/1.0/msvc_x86_64/bin;${Platform.environment['PATH']}',
        'PKG_CONFIG_PATH': 'C:/Program Files/gstreamer/1.0/msvc_x86_64/lib/pkgconfig',
      },
    );
    await rustBuilder.run(input: input, output: output);
  });
}
