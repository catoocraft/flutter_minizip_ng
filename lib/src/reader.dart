import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'common.dart';

void zipExtractSync(File path, Directory destination, String? password) {
  _zipExtract(path, destination, password);
}

Future<void> zipExtract(File path, Directory destination, String? password) {
  return Isolate.run(() => _zipExtract(path, destination, password));
}

void _zipExtract(File path, Directory destination, String? password) {
  final pathC = path.path.toNativeUtf8().cast<Char>();
  final destinationC = destination.path.toNativeUtf8().cast<Char>();
  final passwordC =
      password == null ? nullptr : password.toNativeUtf8().cast<Char>();
  final err = bindings.zip_extract(pathC, destinationC, passwordC);
  malloc.free(pathC);
  malloc.free(destinationC);
  if (passwordC != nullptr) {
    malloc.free(passwordC);
  }
  if (err != 0) {
    throw ZipException('Cannot extract Zip file [$err]');
  }
}
