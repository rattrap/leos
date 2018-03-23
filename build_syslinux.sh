#!/bin/sh
set -ex

if [ ! -f syslinux.tar.xz ]; then
	wget -q -O syslinux.tar.xz http://kernel.org/pub/linux/utils/boot/syslinux/syslinux-$SYSLINUX_VERSION.tar.xz
fi

if [ -d syslinux-$SYSLINUX_VERSION ]; then
	rm -rf syslinux-$SYSLINUX_VERSION
fi

tar -xf syslinux.tar.xz

cd isoimage

cp ../syslinux-$SYSLINUX_VERSION/bios/core/isolinux.bin .
cp ../syslinux-$SYSLINUX_VERSION/bios/com32/elflink/ldlinux/ldlinux.c32 .
echo 'default kernel.xz initrd=rootfs.gz' > ./isolinux.cfg

xorriso \
  -as mkisofs \
  -o ../leos.iso \
  -b isolinux.bin \
  -c boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  ./

cd ..
set +ex
