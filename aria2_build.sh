#!/bin/bash
set -o errexit

sudo apt-get install autopoint gettext

cat '/etc/ssl/certs/ca-certificates.crt' > /dev/null
if [ "$?" -eq 0 ] ; then
CRT='/etc/ssl/certs/ca-certificates.crt'
else
CRT='./certs/ca-certificates.crt'
fi

# CPUCOUNT=$(grep -c ^processor /proc/cpuinfo)

#c-ares
rm -rf c-ares_git
git clone --depth=1 https://github.com/c-ares/c-ares.git c-ares_git
cd c-ares_git
autoreconf -fi
./configure \
    --disable-shared \
    --enable-static \
    --without-random \
    --disable-tests 

make
sudo make install
cd ../
rm -rf c-ares_git
#c-ares

#expat
rm -rf libexpat_git
git clone --depth=1 https://github.com/libexpat/libexpat.git libexpat_git
cd libexpat_git/expat
./buildconf.sh
./configure \
    --disable-shared \
    --enable-static 
make
sudo make install
cd ../../
rm -rf libexpat_git 
#expat

#libssh2
rm -rf libssh2_git
git clone --depth=1 https://github.com/libssh2/libssh2.git libssh2_git
cd libssh2_git
autoreconf -fi
./configure \
    --without-libgcrypt \
    --with-openssl \
    --without-wincng \
    --enable-static \
    --disable-shared
make
sudo make install
cd ../
rm -rf libssh2_git
#libssh2

#sql
rm -rf sqlite_git
git clone --depth=1 https://github.com/sqlite/sqlite.git sqlite_git
cd sqlite_git
./configure \
    --disable-shared \
    --enable-static 
make
sudo make install
cd ../
rm -rf sqlite_git 
#sql

rm -rf aria2_git
git clone --depth=1 https://github.com/aria2/aria2.git aria2_git
cd aria2_git
git apply ../patch/1.patch

autoreconf -fi

## BUILD ##
./configure \
    --without-libxml2 \
    --without-libgcrypt \
    --with-openssl \
    --without-libnettle \
    --without-gnutls \
    --without-libgmp \
    --with-libssh2 \
    --with-sqlite3 \
    --with-ca-bundle=$CRT \
    ARIA2_STATIC=yes \
    --enable-shared=no

make
cd ..
cp aria2_git/src/aria2c* ./
rm -rf aria2_git