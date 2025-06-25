#include "flutter_minizip_ng.h"

#include "minizip-ng/mz.h"
#include "minizip-ng/mz_crypt.h"
#include "minizip-ng/mz_os.h"
#include "minizip-ng/mz_strm.h"
#include "minizip-ng/mz_strm_buf.h"
#include "minizip-ng/mz_strm_mem.h"
#include "minizip-ng/mz_strm_os.h"
#include "minizip-ng/mz_strm_split.h"
#include "minizip-ng/mz_strm_wzaes.h"
#include "minizip-ng/mz_zip.h"

#include "minizip-ng/mz_zip_rw.h"

FFI_PLUGIN_EXPORT int32_t zip_extract(const char *path, const char *destination,
                                  const char *password) {
    void *reader = NULL;
    int32_t err = MZ_OK;
    int32_t err_close = MZ_OK;

    /* Create zip reader */
    reader = mz_zip_reader_create();
    if (!reader)
        return MZ_MEM_ERROR;

    mz_zip_reader_set_password(reader, password);

    err = mz_zip_reader_open_file(reader, path);

    if (err != MZ_OK) {
        printf("Error %" PRId32 " opening archive %s\n", err, path);
    } else {
        /* Save all entries in archive to destination directory */
        err = mz_zip_reader_save_all(reader, destination);

        if (err == MZ_END_OF_LIST) {
            printf("No files in archive\n");
            err = MZ_OK;
        } else if (err != MZ_OK) {
            printf("Error %" PRId32 " saving entries to disk %s\n", err, destination);
        }
    }

    err_close = mz_zip_reader_close(reader);
    if (err_close != MZ_OK) {
        printf("Error %" PRId32 " closing archive for reading\n", err_close);
        err = err_close;
    }

    mz_zip_reader_delete(&reader);
    return err;
}


FFI_PLUGIN_EXPORT void* zip_create(const char *path, const char *password) {
    void *writer = NULL;
    int32_t err = MZ_OK;

    writer = mz_zip_writer_create();
    if (!writer)
        return NULL; //MZ_MEM_ERROR;
    mz_zip_writer_set_password(writer, password);
    mz_zip_writer_set_compress_method(writer, MZ_COMPRESS_METHOD_DEFLATE);
    mz_zip_writer_set_compress_level(writer, MZ_COMPRESS_LEVEL_DEFAULT);

    err = mz_zip_writer_open_file(writer, path, 0, 0);
    if (err != MZ_OK) {
        mz_zip_writer_delete(&writer);
        return NULL;
    }
    return writer;
}

FFI_PLUGIN_EXPORT int32_t zip_write_file(void* writer, const char *name, const char *filename) {
    int32_t err = MZ_OK;

    err = mz_zip_writer_add_file(writer, filename, name);
    if (err != MZ_OK)
      printf("Error %" PRId32 " adding path to archive %s\n", err, filename);

    return err;
}

FFI_PLUGIN_EXPORT int32_t
zip_write_data(void *writer, const char *name, void *buffer, int32_t buf_size) {
    int32_t err = MZ_OK;

    mz_zip_file info = {0};
    info.filename = name;
    info.modified_date = time(NULL);
    info.version_madeby = MZ_VERSION_MADEBY;
    //info.version_madeby = (MZ_HOST_UNIX << 8) | 20; // Unix ホスト + バージョン 2.0
    info.compression_method = MZ_COMPRESS_METHOD_STORE;
    // info.flag = MZ_ZIP_FLAG_UTF8;
    info.external_fa = (0600 << 16); // Unix パーミッションをセット

    err = mz_zip_writer_add_buffer(writer, buffer, buf_size, &info);
    if (err != MZ_OK)
        printf("Error %" PRId32 " adding data to archive %s\n", err, name);

    return err;
}

FFI_PLUGIN_EXPORT int32_t zip_close(void* writer) {
    int32_t err = MZ_OK;
    int32_t err_close = MZ_OK;
    err_close = mz_zip_writer_close(writer);
    if (err_close != MZ_OK) {
        printf("Error %" PRId32 " closing archive for writing\n", err_close);
        err = err_close;
    }
    mz_zip_writer_delete(&writer);
    return err;
}
