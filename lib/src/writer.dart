import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'common.dart';

typedef ZipHandle = Pointer<Void>;

class ZipFileWriterSync {
  ZipHandle? _handle;

  void create(File file, String? password) {
    if (_handle != null) {
      throw ZipException('ZipFileWriter already created; call close() first');
    }
    _handle = _create(file, password);
  }

  void close() {
    if (_handle != null) {
      _close(_handle!);
    }
    _handle = null;
  }

  void writeFile(String name, File file) =>
      _writeFile(_checkCreated(_handle), name, file);

  void writeData(String name, Uint8List data) =>
      _writeData(_checkCreated(_handle), name, data);
}


class ZipFileWriter {
  ZipHandle? _handle;

  Future<void> create(File file, String? password) async {
    if (_handle != null) {
      throw ZipException('ZipFileWriter already created; call close() first');
    }
    _handle = await Isolate.run(() => _create(file, password));
  }

  Future<void> close() async {
    if (_handle != null) {
      await Isolate.run(() => _close(_handle!));
      _handle = null;
    }
  }

  Future<void> writeFile(String name, File file) async {
    final handle = _checkCreated(_handle);
    await Isolate.run(() => _writeFile(handle, name, file));
  }

  Future<void> writeData(String name, Uint8List data) async {
    final handle = _checkCreated(_handle);
    await Isolate.run(() => _writeData(handle, name, data));
  }

  ZipHandle _checkCreated(ZipHandle? handle) {
    if (handle == null) {
      throw ZipException('Zip file has not yet been created');
    }
    return handle;
  }
}

ZipHandle _create(File file, String? password) {
  final nativeFilePath = file.path.toNativeUtf8().cast<Char>();
  final passwordC =
      password == null ? nullptr : password.toNativeUtf8().cast<Char>();
  final handle = bindings.zip_create(nativeFilePath, passwordC);
  malloc.free(nativeFilePath);
  if (handle.address == 0) {
    throw ZipException('Cannot create Zip file at "${file.path}"');
  }
  return handle;
}

void _writeFile(ZipHandle handle, String name, File file) {
  final nameC = name.toNativeUtf8().cast<Char>();
  final nativeFilePath = file.path.toNativeUtf8().cast<Char>();
  final err = bindings.zip_write_file(handle, nameC, nativeFilePath);
  malloc.free(nameC);
  malloc.free(nativeFilePath);
  if (err != 0) {
    throw ZipException('Cannot write file "${file.path}" to Zip file [$err]');
  }
}

void _writeData(ZipHandle handle, String name, Uint8List data) {
    final nativeName = name.toNativeUtf8().cast<Char>();

    final bufferPointer = malloc<Uint8>(data.length);
    final buffer = bufferPointer.asTypedList(data.length);
    buffer.setAll(0, data);

    final err = bindings.zip_write_data(
        handle, nativeName, bufferPointer.cast<Void>(), data.length);
    malloc.free(nativeName);
    malloc.free(bufferPointer);
    if (err != 0) {
      throw ZipException('Cannot write data to Zip file [$err]');
    }
}

void _close(ZipHandle handle) {
  final err = bindings.zip_close(handle);
  if (err != 0) {
    throw ZipException('Cannot close Zip file [$err]');
  }
}

ZipHandle _checkCreated(ZipHandle? handle) {
  if (handle == null) {
    throw ZipException('Zip file has not yet been created');
  }
  return handle;
}
