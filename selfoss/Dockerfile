FROM xataz/nginx-php:latest

MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="2016110812" \
      tags="latest"

ENV UID=991 GID=991 VER=2.15 CRON_PERIOD=15m

ADD https://github.com/SSilence/selfoss/releases/download/${VER}/selfoss-${VER}.zip /tmp/

RUN apk add --update \
		unzip \
    git && \
  	mkdir -p /selfoss /etc/s6.d/.s6-svscan && \
  	unzip /tmp/selfoss-*.zip -d /selfoss && \
    git clone -q https://github.com/bcosca/fatfree --depth=1 /tmp/f3 && \
    rm -rf /selfoss/libs/f3/* && mv /tmp/f3/lib/* /selfoss/libs/f3/ && \
  	cp -R /selfoss/data /selfoss/bkp &&\
    rm -rf /var/cache/apk/* /tmp/*  && apk del unzip git

COPY rootfs /
RUN chmod +x /usr/local/bin/startup /etc/s6.d/*/*

EXPOSE 8080
VOLUME /selfoss/data

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]
