#!/bin/sh

#Delete old files
[[ -e /var/cache/unbound/root* ]] && rm -f /var/cache/unbound/root*

#Update root information
curl -s https://www.internic.net/domain/named.cache -o /var/cache/unbound/root.hints

#Update root-anchors
unbound-anchor -a /var/cache/unbound/root-anchors.txt
chown unbound:unbound /var/cache/unbound/root-anchors.txt