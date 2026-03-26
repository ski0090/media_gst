// ignore_for_file: avoid_print
import 'dart:io';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void _patchFrbGenerated() {
  final f = File('lib/src/rust/frb_generated.io.dart');
  if (!f.existsSync()) return;
  String c = f.readAsStringSync();

  // 이미 패치되어 있다면 스킵합니다.
  if (c.contains('// typedef bool removed manually')) return;
  
  c = c.replaceAll('typedef bool = ffi.NativeFunction<ffi.Int Function(ffi.Pointer<ffi.Int>)>;', '// typedef bool removed manually');
  c = c.replaceAll('external bool use_hardware_acceleration;', '@ffi.Bool() external bool use_hardware_acceleration;');
  c = c.replaceAll('external bool enable_audio;', '@ffi.Bool() external bool enable_audio;');
  
  c = c.replaceAll('ffi.Pointer<bool> is_sync,', 'bool is_sync,');
  c = c.replaceAll('ffi.Pointer<bool>,', 'bool,');
  c = c.replaceAll('ffi.Pointer<ffi.Bool> is_sync,', 'bool is_sync,');
  c = c.replaceAll('ffi.Pointer<ffi.Bool>,', 'bool,');
  
  c = c.replaceAll('ans.ref.ptr.asTypedList(raw.length)', 'ans.ref.ptr.cast<ffi.Uint8>().asTypedList(raw.length)');
  
  f.writeAsStringSync(c);
  print('[hook/build.dart] FFIGen bool translation bug dynamically patched.');
}

/// Flutter Native Assets 빌드 훅
///
/// `flutter run` 또는 `flutter build` 시 자동으로 트리거되어
/// Rust 크레이트(`media_gst_native`)를 컴파일하고 네이티브 라이브러리로 링킹합니다.
///
/// [ENV.md] 섹션 2 "네이티브 에셋 자동화 구조" 참조.
/// [native_toolchain_rust 1.x API 기준]
void main(List<String> args) async {
  // 빌드 시 FFIGen Windows 버그를 자동으로 패치합니다.
  try {
    _patchFrbGenerated();
  } catch (e) {
    print('Failed to patch FRB: $e');
  }

  await build(args, (input, output) async {
    await RustBuilder(
      assetName: 'frb_generated.dart',
    ).run(
      input: input,
      output: output,
    );
  });
}
