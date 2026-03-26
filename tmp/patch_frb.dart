import 'dart:io';

void main() {
  final f = File('lib/src/rust/frb_generated.io.dart');
  if (!f.existsSync()) return;
  String c = f.readAsStringSync();
  
  c = c.replaceAll('typedef bool = ffi.NativeFunction<ffi.Int Function(ffi.Pointer<ffi.Int>)>;', '// typedef bool removed');
  c = c.replaceAll('external bool use_hardware_acceleration;', '@ffi.Bool() external bool use_hardware_acceleration;');
  c = c.replaceAll('external bool enable_audio;', '@ffi.Bool() external bool enable_audio;');
  
  // Method mapping FFI bool pointers to bool
  c = c.replaceAll('ffi.Pointer<bool> is_sync,', 'bool is_sync,');
  c = c.replaceAll('ffi.Pointer<bool>,', 'bool,');
  c = c.replaceAll('ffi.Pointer<ffi.Bool> is_sync,', 'bool is_sync,');
  c = c.replaceAll('ffi.Pointer<ffi.Bool>,', 'bool,');
  
  // Uint8List cast fallback
  c = c.replaceAll('ans.ref.ptr.asTypedList(raw.length)', 'ans.ref.ptr.cast<ffi.Uint8>().asTypedList(raw.length)');
  
  f.writeAsStringSync(c);
  print('Patched successfully');
}
