# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_minizip_ng_library VERSION 0.0.1 LANGUAGES C)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DZLIB_COMPAT -DHAVE_ZLIB -DHAVE_PKCRYPT")

set(MINIZIP_SRC
        #minizip-ng/mz_crypt_apple.c
        minizip-ng/mz_crypt_openssl.c
        minizip-ng/mz_crypt.c
        minizip-ng/mz_os_posix.c
        minizip-ng/mz_os.c
        minizip-ng/mz_strm_buf.c
        #minizip-ng/mz_strm_libcomp.c
        minizip-ng/mz_strm_mem.c
        minizip-ng/mz_strm_os_posix.c
        minizip-ng/mz_strm_pkcrypt.c
        minizip-ng/mz_strm_split.c
        #minizip-ng/mz_strm_wzaes.c
        minizip-ng/mz_strm_zlib.c
        minizip-ng/mz_strm.c
        minizip-ng/mz_zip_rw.c
        minizip-ng/mz_zip.c)


# flutter_minizip_ng ライブラリに minizip-ng のソースを追加
add_library(flutter_minizip_ng SHARED
        flutter_minizip_ng.c
        ${MINIZIP_SRC}
)

set_target_properties(flutter_minizip_ng PROPERTIES
        PUBLIC_HEADER flutter_minizip_ng.h
        OUTPUT_NAME "flutter_minizip_ng"
)

# minizip-ng, openssl のヘッダーファイルがあるディレクトリをインクルードパスに追加
target_include_directories(flutter_minizip_ng PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/minizip-ng"
        "${CMAKE_CURRENT_SOURCE_DIR}/openssl"
)

target_compile_definitions(flutter_minizip_ng PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(flutter_minizip_ng PRIVATE "-Wl,-z,max-page-size=16384")

  # ZLIB ライブラリをリンク
  find_library(ZLIB_LIB z)
  target_link_libraries(flutter_minizip_ng PRIVATE ${ZLIB_LIB})

  # ビルド済み openssl の so をリンク
  add_library(crypto SHARED IMPORTED)
  set_target_properties(crypto PROPERTIES
          IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/openssl/lib/${ANDROID_ABI}/libcrypto.so
  )
  target_link_libraries(flutter_minizip_ng PRIVATE crypto)
endif()
