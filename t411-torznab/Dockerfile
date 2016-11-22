FROM xataz/node:latest-onbuild
MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201611222" \
      tags="latest"

ENV GID=991 UID=991 USERNAME="t411" PASSWORD="t411"

ADD startup /usr/bin/startup
RUN chmod +x /usr/bin/startup

CMD ["startup"]
