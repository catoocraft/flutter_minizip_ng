import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_minizip_ng/flutter_minizip_ng.dart' as flutter_minizip_ng;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body:
        SingleChildScrollView(
          child: Center(
            child:
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ElevatedButton(onPressed: unzipSync, child: Text("UnzipSync")),
                  spacerSmall,
                  ElevatedButton(onPressed: unzipEncSync, child: Text("UnzipEncSync")),
                  spacerSmall,
                  ElevatedButton(onPressed: unzip, child: Text("Unzip")),
                  spacerSmall,
                  ElevatedButton(onPressed: unzipEnc, child: Text("UnzipEnc")),
                  spacerSmall,
                  ElevatedButton(onPressed: createZipSync, child: Text("CreateZipSync")),
                  spacerSmall,
                  ElevatedButton(onPressed: createZip, child: Text("CreateZip")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> unzipSync() async {
    _unzipSync('test.zip', null);
  }
  

  Future<void> unzipEncSync() async {
    _unzipSync('test_enc.zip', 'test_password');
  }

  Future<void> _unzipSync(String zipFilename, String? password) async {
    final temp = await getTemporaryDirectory();
    final dest = Directory("${temp.path}/dest");
    if (dest.existsSync()) {
      dest.deleteSync(recursive: true);
    }
    await dest.create(recursive: true);
    final zip = await getFileFromAssets(zipFilename);
    flutter_minizip_ng.zipExtractSync(zip, dest, password);

    _checkExtract(dest, zipFilename);
  }

  Future<void> unzip() async {
    _unzip('test.zip', null);
  }

  Future<void> unzipEnc() async {
    _unzip('test_enc.zip', 'test_password');
  }

  Future<void> _unzip(String zipFilename, String? password) async {
    final temp = await getTemporaryDirectory();
    final dest = Directory("${temp.path}/dest");
    if (dest.existsSync()) {
      dest.deleteSync(recursive: true);
    }
    await dest.create(recursive: true);
    final zip = await getFileFromAssets(zipFilename);
    await flutter_minizip_ng.zipExtract(zip, dest, password);
    _checkExtract(dest, zipFilename);
  }

  Future<void> _checkExtract(Directory dest, String zipFilename) async {
    File("${dest.path}/test/short_text.txt").readAsString().then((value) {
      assert(value == '''Hello.
''');
    });
    File("${dest.path}/test/dir/normal_text.txt").readAsString(encoding: utf8).then((value) {
      assert(value == '''Hello, world !
みなさん、こんにちは。

徒然草の冒頭の文は「つれづれなるままに、日暮らし、硯にむかひて、心にうつりゆくよしなしごとを、そこはかとなく書きつくれば、あやしうこそものぐるほしけれ。」です。
''');
    });
    assert(File("${dest.path}/test/dir/sheep.jpg").existsSync() == true);
    print("unzip succeeded $zipFilename");
  }


  Future<void> createZipSync() async {
    final temp = await getTemporaryDirectory();
    final dest = Directory("${temp.path}/dest");
    await dest.create(recursive: true);
    final normalTextFile = await getFileFromAssets("normal_text.txt");
    final jpgFile = await getFileFromAssets("sheep.jpg");
    final writer = flutter_minizip_ng.ZipFileWriterSync();
    try {
      final zip = File("${temp.path}/test_enc.zip");
      if (zip.existsSync()) {
        zip.deleteSync();
      }
      writer.create(File("${temp.path}/test_enc.zip"), "test_password");
      writer.writeData("test/short_text.txt", utf8.encode('''Hello.
'''));
      writer.writeFile("test/dir/normal_text.txt", normalTextFile);
      writer.writeFile("test/dir/sheep.jpg", jpgFile);
      writer.close();
      print("create zip succeeded.");
    } catch (e) {
      print("error occurred: $e");
    }
  }

  Future<void> createZip() async {
    final temp = await getTemporaryDirectory();
    final dest = Directory("${temp.path}/dest");
    await dest.create(recursive: true);
    final normalTextFile = await getFileFromAssets("normal_text.txt");
    final jpgFile = await getFileFromAssets("sheep.jpg");
    final writer = flutter_minizip_ng.ZipFileWriter();
    try {
      final zip = File("${temp.path}/test_enc.zip");
      if (zip.existsSync()) {
        zip.deleteSync();
      }
      await writer.create(File("${temp.path}/test_enc.zip"), "test_password");
      await writer.writeData("test/short_text.txt", utf8.encode('''Hello.
'''));
      await writer.writeFile("test/dir/normal_text.txt", normalTextFile);
      await writer.writeFile("test/dir/sheep.jpg", jpgFile);
      await writer.close();
      print("create zip succeeded.");
    } catch (e) {
      print("error occurred: $e");
    }
  }
}
