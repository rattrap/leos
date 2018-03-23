#!/bin/sh
set -ex

if [ ! -f kernel.tar.xz ]; then
	wget -q -O kernel.tar.xz http://kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
fi

if [ -d linux-$KERNEL_VERSION ]; then
	rm -rf linux-$KERNEL_VERSION
fi

tar -xf kernel.tar.xz

cd linux-$KERNEL_VERSION

make -j5 defconfig

# Kernel config options
sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"LeOS\"/" .config
sed -i "s/.*\\(CONFIG_KERNEL_.*\\)=y/\\#\\ \\1 is not set/" .config
sed -i "s/.*CONFIG_KERNEL_XZ.*/CONFIG_KERNEL_XZ=y/" .config
sed -i "s/.*CONFIG_FB_VESA.*/CONFIG_FB_VESA=y/" .config
sed -i "s/.*CONFIG_LOGO_LINUX_CLUT224.*/CONFIG_LOGO_LINUX_CLUT224=y/" .config
sed -i "s/^CONFIG_DEBUG_KERNEL.*/\\# CONFIG_DEBUG_KERNEL is not set/" .config
sed -i "s/.*CONFIG_EFI_STUB.*/CONFIG_EFI_STUB=y/" .config
echo "CONFIG_RESET_ATTACK_MITIGATION=y" >> .config
echo "CONFIG_APPLE_PROPERTIES=n" >> .config
if [ "`grep "CONFIG_X86_64=y" .config`" = "CONFIG_X86_64=y" ] ; then
	echo "CONFIG_EFI_MIXED=y" >> .config
fi

make -j5 bzImage

cp arch/x86/boot/bzImage ../isoimage/kernel.gz
cd ..

set +ex
