# flutter_minizip_ng

A Flutter FFI plugin that provides access to [minizip-ng](https://github.com/zlib-ng/minizip-ng) functionality from Dart.  
This plugin enables ZIP archive creation and extraction using native code on **Android**, **iOS**, and **macOS**.

## Features

- Create and extract ZIP archives
- Support for password-protected and encrypted ZIP files
- Works on Android, iOS, and macOS
- Uses [minizip-ng](https://github.com/zlib-ng/minizip-ng) for ZIP processing
- OpenSSL support on Android for encryption

## Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ macOS

## Included Native Libraries

This plugin includes the following third-party libraries:

### 🗜️ minizip-ng 4.0.10

- Source code is bundled under `src/minizip_ng/`
- Official repository: https://github.com/zlib-ng/minizip-ng
- License: [Zlib License](https://github.com/zlib-ng/minizip-ng/blob/develop/LICENSE)

### 🔐 OpenSSL 3.5.0 (Android only)

- Precompiled `.so` binaries and headers are included under `src/openssl/`
- Built for the following Android ABIs:
    - `armeabi-v7a`
    - `arm64-v8a`
    - `x86`
    - `x86_64`
- Official website: https://www.openssl.org/
- License: [Apache License 2.0 and OpenSSL License](https://www.openssl.org/source/license-openssl-3.0.html)

> ⚠️ OpenSSL is currently used only on Android. On iOS/macOS, native Apple cryptographic libraries are used (or no encryption if not supported).

## Getting Started

Add this plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_minizip_ng:
    git:
      url: https://github.com/catoocraft/flutter_minizip_ng.git
```

Then import and use it in your Dart code:

```dart
import 'package:flutter_minizip_ng/flutter_minizip_ng.dart';
```

## License

This plugin is distributed under the **MIT License**. See [LICENSE](LICENSE) for full details.

### Third-party Components

The following third-party libraries are bundled:

| Library    | Version | License                                                   |
|------------|---------|-----------------------------------------------------------|
| minizip-ng | 4.0.10  | [Zlib License](src/minizip-ng/LICENSE)                    |
| OpenSSL    | 3.5.0   | [Apache 2.0 and OpenSSL License](src/openssl/LICENSE.txt) |

You are responsible for ensuring compliance with each library’s license when redistributing this plugin or your app.

## Rebuilding Native Libraries

To rebuild OpenSSL or minizip-ng manually (e.g., for newer versions or other platforms), consult the respective upstream documentation:

- [minizip-ng build instructions](https://github.com/zlib-ng/minizip-ng#build)
- [OpenSSL build for Android](https://wiki.openssl.org/index.php/Android)

Below is a sample openssl build script.

~~~shell
#!/bin/sh

export ANDROID_NDK_HOME=/Users/user/Library/Android/sdk/ndk/27.0.12077973
PATH=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH
make clean
./Configure android-arm64 -D__ANDROID_API__=29
#./Configure android-arm -D__ANDROID_API__=29
#./Configure android-x86 -D__ANDROID_API__=29
#./Configure android-x86_64 -D__ANDROID_API__=29
make SHLIB_EXT='.so'
~~~

## Acknowledgements

This plugin was initially inspired by the [async_zip](https://pub.dev/packages/async_zip) library.
While async_zip provided a great foundation, this plugin was created to support password-protected ZIP files via minizip-ng.

We would like to thank the authors of async_zip for their clean API design and documentation, which served as a helpful reference during development.

## Disclaimer

This project is **not affiliated with** the authors of minizip-ng or OpenSSL.  
All trademarks and copyrights are the property of their respective owners.
