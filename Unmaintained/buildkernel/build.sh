#!/bin/bash

mkdir -p /root
cd /root
test -f linux-${VERSION}.tar.xz || wget --no-check-certificate https://www.kernel.org/pub/linux/kernel/v${VERSION%%.*}.x/linux-${VERSION}.tar.xz

cd /usr/src
test -d linux-${VERSION} || tar xJvfp /root/linux-${VERSION}.tar.xz

cd /usr/src/linux-${VERSION}
test -f /data/config && cp /data/config .config

tty > /dev/null && make menuconfig && cp .config /data/config

REL=4.3
mkdir -p /data/boot

make-kpkg --initrd --append-to-version=-$(date '+%Y%m%d') kernel-image kernel-headers
for file in $(find /usr/src -name *.deb);do
  cp $file /data
  echo $file;
done
