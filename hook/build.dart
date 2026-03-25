// ignore_for_file: avoid_print
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

/// Flutter Native Assets 빌드 훅
///
/// `flutter run` 또는 `flutter build` 시 자동으로 트리거되어
/// Rust 크레이트(`media_gst_native`)를 컴파일하고 네이티브 라이브러리로 링킹합니다.
///
/// [ENV.md] 섹션 2 "네이티브 에셋 자동화 구조" 참조.
/// [native_toolchain_rust 1.x API 기준]
void main(List<String> args) async {
  await build(args, (input, output) async {
    await RustBuilder(
      assetName: 'frb_generated.dart',
    ).run(
      input: input,
      output: output,
    );
  });
}
