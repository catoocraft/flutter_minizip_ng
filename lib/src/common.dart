import 'dart:ffi';
import 'dart:io';

import 'bindings_generated.dart';

const String _libName = 'flutter_minizip_ng';

/// The dynamic library in which the symbols for [FlutterMinizipNgBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FlutterMinizipNgBindings bindings = FlutterMinizipNgBindings(_dylib);

/// Notifies the caller about a failed operation when dealing with
/// [ZipFileReader] and [ZipFileWriter] or their respective asynchronous
/// counterparts [ZipFileReaderAsync] and [ZipFileWriterAsync].
class ZipException implements Exception {
  /// The message describing the failed operation.
  final String message;

  /// Creates a new exception with the specified message.
  ZipException(this.message);

  @override
  String toString() {
    return 'ZipException($message)';
  }
}
