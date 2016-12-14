FROM	eboraas/debian:jessie

MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201608107" \
      tags="latest"


ENV	VERSION=4.9

WORKDIR	/usr/src

RUN apt-get update && apt-get install -y --no-install-recommends \
		cpio \
		ca-certificates \
		wget \
		tar \
		libncurses-dev \
		build-essential \
		fakeroot \
		kernel-package \
		u-boot-tools \
		zlib1g-dev \
		libncurses5-dev \
		liblz4-tool
ADD	build.sh /root/
RUN	chmod a+x /root/build.sh

VOLUME	[ "/data" ]

CMD	["/root/build.sh"]
