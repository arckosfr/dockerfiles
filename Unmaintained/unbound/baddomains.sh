#!/bin/sh

unboundpid="/var/run/unbound/unbound.pid"
adfile="/var/cache/unbound/adfile.list"
adurl="http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext"
malwarefile="/var/cache/unbound/malwarefile.list"
malwareurl="http://mirror1.malwaredomains.com/files/BOOT"

#Ads
if [ -e $adfile ]; then rm $adfile; fi
for i in `wget -q -O - $adurl`; do
  echo "local-data: \"$i A 127.0.0.1\"" >> $adfile
done

#Malwares
if [ -e $malwarefile ]; then rm $malwarefile; fi
wget -q -O $malwarefile.tmp http://mirror1.malwaredomains.com/files/BOOT
cat $malwarefile.tmp | grep "^PRIMARY" | cut -d " " -f2 > $malwarefile.tmp2
while read i; do
  echo "local-data:\"$i A 127.0.0.1\"" >> $malwarefile
done < $malwarefile.tmp2
rm $malwarefile.tmp*

#Reload
if [ -e $unboundpid ]; then kill -HUP `cat $unboundpid`; fi