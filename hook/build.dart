import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final rustBuilder = RustBuilder(
      assetName: 'media_gst', // asset_id for Native Assets
      cratePath: 'rust',
    );
    await rustBuilder.run(input: input, output: output);
  });
}
