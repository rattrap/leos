#!/bin/sh
set -ex

if [ ! -f glibc.tar.bz2 ]; then
	wget -q -O glibc.tar.bz2 http://ftp.gnu.org/gnu/glibc/glibc-$GLIBC_VERSION.tar.bz2
fi

if [ -d glibc-$GLIBC_VERSION ]; then
	rm -rf glibc-$GLIBC_VERSION
fi

tar -xjf glibc.tar.bz2

if [ -d glibc_build ]; then
	rm -rf glibc_build
fi

mkdir glibc_build

if [ -d glibc_install ]; then
	rm -rf glibc_install
fi

mkdir glibc_install

cd glibc_build

./../glibc-$GLIBC_VERSION/configure \
  --prefix= \
  --with-headers=`realpath ../linux_install/include` \
  --without-gd \
  --without-selinux \
  --disable-werror

make -j 5

make install \
  DESTDIR=`realpath ../glibc_install` \
  -j 5

cd ..
cd busybox-$BUSYBOX_VERSION/_install
mkdir -p lib
cp ../../glibc_install/lib/libnss_files.so.2 lib/libnss_files.so
cp ../../glibc_install/lib/libresolv.so.2 lib/libresolv.so
cp ../../glibc_install/lib/libnss_dns.so.2 lib/libnss_dns.so.2
cd lib; ln -s libnss_dns.so.2 libnss_dns.so; cd ..

set +e
strip -g lib/*
set -e

cd ../../

set +ex
