#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT int32_t zip_extract(const char *path, const char *destination,
                                  const char *password);

FFI_PLUGIN_EXPORT void* zip_create(const char *path, const char *password);

FFI_PLUGIN_EXPORT int32_t zip_write_file(void* writer, const char *name, const char *file_path);

FFI_PLUGIN_EXPORT int32_t zip_write_data(void* writer, const char *name, void *buffer, int32_t buf_size);

FFI_PLUGIN_EXPORT int32_t zip_close(void* writer);
