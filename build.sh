#!/bin/sh
set -ex

./build_kernel.sh
./build_busybox.sh
./build_syslinux.sh

set +ex
