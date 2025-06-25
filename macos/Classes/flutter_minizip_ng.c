// Relative import to be able to reuse the C sources.
// See the comment in ../flutter_minizip_ng.podspec for more information.
#include "../../src/flutter_minizip_ng.c"

#define HAVE_LIBCOMP
#define HAVE_PKCRYPT

#include "../../src/minizip-ng/mz_crypt_apple.c"
//#include "../../src/minizip-ng/mz_crypt_openssl.c"
//#include "../../src/minizip-ng/mz_crypt_winvista.c"
//#include "../../src/minizip-ng/mz_crypt_winxp.c"
#include "../../src/minizip-ng/mz_crypt.c"
#include "../../src/minizip-ng/mz_os_posix.c"
//#include "../../src/minizip-ng/mz_os_win32.c"
#include "../../src/minizip-ng/mz_os.c"
#include "../../src/minizip-ng/mz_strm_buf.c"
//#include "../../src/minizip-ng/mz_strm_bzip.c"
#include "../../src/minizip-ng/mz_strm_libcomp.c"
//#include "../../src/minizip-ng/mz_strm_lzma.c"
#include "../../src/minizip-ng/mz_strm_mem.c"
#include "../../src/minizip-ng/mz_strm_os_posix.c"
//#include "../../src/minizip-ng/mz_strm_os_win32.c"
#include "../../src/minizip-ng/mz_strm_pkcrypt.c"
#include "../../src/minizip-ng/mz_strm_split.c"
//#include "../../src/minizip-ng/mz_strm_wzaes.c"
//#include "../../src/minizip-ng/mz_strm_zlib.c"
//#include "../../src/minizip-ng/mz_strm_zstd.c"
#include "../../src/minizip-ng/mz_strm.c"
#include "../../src/minizip-ng/mz_zip_rw.c"
#include "../../src/minizip-ng/mz_zip.c"
