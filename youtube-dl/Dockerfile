FROM xataz/alpine:3.4
MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201611101" \
      tags="latest"

RUN apk add --update python \
                     py-pip \
					 ffmpeg \
					 ca-certificates \
 && pip install --upgrade pip youtube_dl \
 && mkdir /download \
 apk del py-pip && rm -rf /var/cache/apk/* ~/.pip/cache/*
WORKDIR /download
ENTRYPOINT ["youtube-dl"]
CMD ["--help"]
