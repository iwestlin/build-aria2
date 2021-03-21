rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
copy /y ./patch/src ./aria2_git/
cd aria2_git

autoreconf -fi

## BUILD ##
PREFIX=/usr/x86_64-w64-mingw32

./configure \
    --prefix=$PREFIX \
    --without-included-gettext \
    --disable-nls \
    --with-libcares \
    --without-gnutls \
    --without-wintls \
    --with-openssl \
    --with-sqlite3 \
    --without-libxml2 \
    --with-libexpat \
    --with-libz \
    --without-libgmp \
    --with-libssh2 \
    --without-libgcrypt \
    --without-libnettle \
    --with-cppunit-prefix=$PREFIX \
    ARIA2_STATIC=yes \
    CPPFLAGS="-I$PREFIX/include" \
    LDFLAGS="-L$PREFIX/lib" \
    PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

make
cd ..
copy /y aria2_git/src/aria2c ./
rm -rf aria2_git