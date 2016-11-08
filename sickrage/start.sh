#!/bin/sh

cd /SickRage && git pull
[[ ${GID} -ne 0 ]] && addgroup -g ${GID} sickrage && GROUP="sickrage" || GROUP="root"
[[ ${UID} -ne 0 ]] && adduser -h /home/sickrage -s /bin/sh -D -G sickrage -u ${UID} sickrage && USER="sickrage" || USER="root"
if [ ! -f /config/config.ini ]
then
	mv /tmp/config.ini /config/config.ini
	if [ ${TORRENT_METHOD} == "rtorrent" ]
	then
		sed -i "s/<method>/rtorrent/;s/<host>/scgi:\/\/torrent:5000/" /config/config.ini
	elif [ ${TORRENT_METHOD} == "transmission" ]
	then
		sed -i "s/<method>/transmission/;s/<host>/http:\/\/torrent\/torrent\/rpc/" /config/config.ini
	else
		sed -i "s/<method>/blackhole/" /config/config.ini
	fi
fi

chown -R sickrage:sickrage /SickRage
chown -R sickrage:sickrage /config
chown -R sickrage:sickrage /blackhole
chown -R sickrage:sickrage /torrents

su - sickrage -c "/usr/bin/python /SickRage/SickBeard.py --datadir=/config"