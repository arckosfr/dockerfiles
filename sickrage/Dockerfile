FROM xataz/alpine:3.4

MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201608107" \
      tags="latest"
	  
ENV TORRENT_METHOD="rtorrent" UID=5000 GID=5000

ADD start.sh /usr/bin/start.sh
ADD config.ini /tmp/config.ini

RUN apk add --update \
		git \
		python \
		py-pip && \
	pip install \
		cheetah && \
	git clone https://github.com/SickRage/SickRage.git && \
	apk del py-pip && rm -rf /var/cache/apk/* && \
	chmod +x /usr/bin/start.sh

VOLUME [ "/config", "/blackhole", "/torrents"]
EXPOSE 8081

CMD ["usr/bin/tini","--","/usr/bin/start.sh"]