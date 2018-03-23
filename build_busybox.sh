#!/bin/sh
set -ex

if [ ! -f busybox.tar.bz2 ]; then
	wget -q -O busybox.tar.bz2 http://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
fi

if [ -d busybox-$BUSYBOX_VERSION ]; then
	rm -rf busybox-$BUSYBOX_VERSION
fi

tar -xjf busybox.tar.bz2

cd busybox-$BUSYBOX_VERSION

make -j5 distclean
make -j5 defconfig

sed -i "s/.*CONFIG_STATIC.*/CONFIG_STATIC=y/" .config

make -j5 busybox install
cd _install
rm -f linuxrc
mkdir dev proc sys
echo '#!/bin/sh' > init
echo 'dmesg -n 1' >> init
echo 'mount -t devtmpfs none /dev' >> init
echo 'mount -t proc none /proc' >> init
echo 'mount -t sysfs none /sys' >> init
echo 'setsid cttyhack /bin/sh' >> init
chmod +x init

find . | cpio -R root:root -H newc -o | gzip > ../../isoimage/rootfs.gz

cd ../../
set +ex
