FROM xataz/node:latest-onbuild

MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201608107" \
      tags="latest"

RUN apk --update add bash wget git unzip ca-certificates && \
        cd / && git clone https://github.com/Upload/Up1 && \
		cd /Up1/server && \
    apk del wget unzip git && rm -rf /var/cache/apk/* && \
    npm install

ADD start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 5000 5443

WORKDIR /Up1/server

ENV NODE_ENV production UID=1000 GID=1000

ENTRYPOINT ["/start.sh"]
CMD [""]
