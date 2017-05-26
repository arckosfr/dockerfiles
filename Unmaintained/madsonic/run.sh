#!/bin/sh
addgroup -g ${GID} madsonic && adduser -h /madsonic -s /bin/sh -D -G madsonic -u ${UID} madsonic

mkdir -p /data/transcode
ln -s /usr/bin/ffmpeg /data/transcode/ffmpeg
ln -s /usr/bin/lame /data/transcode/lame

chown -R madsonic:madsonic /data /playlists /madsonic

sleep 7 # avoid 503

su madsonic << EOF
java -Xmx200m \
  -Dmadsonic.home=/data \
  -Dmadsonic.host=0.0.0.0 \
  -Dmadsonic.port=4040 \
  -Dmadsonic.httpsPort=0 \
  -Dmadsonic.contextPath=/ \
  -Dmadsonic.defaultMusicFolder=/musics \
  -Dmadsonic.defaultPodcastFolder=/podcasts \
  -Dmadsonic.defaultPlaylistFolder=/playlists \
  -Djava.awt.headless=true \
  -jar madsonic-booter.jar
EOF