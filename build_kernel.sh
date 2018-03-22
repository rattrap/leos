#!/bin/sh
set -ex

if [ ! -f kernel.tar.xz ]; then
	wget -q -O kernel.tar.xz http://kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
fi

tar -xf kernel.tar.xz

cd linux-$KERNEL_VERSION
make -j5 mrproper defconfig bzImage
cp arch/x86/boot/bzImage ../isoimage/kernel.gz
cd ..

set +ex
