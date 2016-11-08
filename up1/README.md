# docker-up1

![Logo](https://avatars2.githubusercontent.com/u/12774718?s=150)

Up1: A Client-side Encrypted Image Host
===

dockerfile for up1 installation

# Intallation
## Installation via docker hub
``docker pull arckosfr/up1``

# Usage
## Volume, port
### PORT
+ 5000	(http)
+ 5443  (https activated only if a certs is present)

### Volume
+ /Up1/server/i			(Upload Folder)
+ /Up1/server/certs		(Certificate Folder)


## Lancement simple
``docker run -d -p 80:5000 arckosfr/up1``

## Lancement avec un volume
``docker run -d -p 80:5000 -p 443:5443 -v /mnt/data:/Up1/server/i -d /mnt/certs:/Up1/server/certs --name up1 arckosfr/up1``
