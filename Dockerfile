FROM ubuntu:16.04

ENV KERNEL_VERSION=4.14.12
ENV BUSYBOX_VERSION=1.27.1
ENV SYSLINUX_VERSION=6.03
ENV GLIBC_VERSION=2.26

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -yq wget bc build-essential gawk cpio xorriso && \
	apt-get clean

RUN install --directory -m 0755 /data

WORKDIR /data
VOLUME /data