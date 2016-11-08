# docker-selfoss
Conteneur Selfoss basé sur alpine


# Intallation
## Installation via docker hub
``docker pull arckosfr/selfoss``

## installation via dockerfile
``git clone https://github.com/arckosfr/selfoss``

``cd docker-selfoss``

``docker build -t arckosfr/selfoss .``


# Usage
## Volume, port
### PORT
+ 8080

### Volume
+ /files


## Lancement simple
``docker run -d -p 80:80 arckosfr/selfoss``

## Lancement avec un volume
``docker run -d -p 80:80 -v /mnt:/selfoss/data --name selfoss arckosfr/selfoss``

## Bonus : reverse proxy nginx
```
location ~* ^/(data\/logs|data\/sqlite|config\.ini|\.ht|password) {
    deny all; # Disable temporarilly to generate a password usingi the `/password` page
}

location /update {
    proxy_set_header Host $http_host;
    proxy_read_timeout 300;
    proxy_pass http://selfoss:80;
}

location / {
    proxy_set_header Host $http_host;
    proxy_pass http://selfoss:80;
}
```

## Auto Update

Add a cronjob somewhere to fetch updates feeds on a regular base. Following line would update the feeds all 15 minutes:

*/15 * * * * curl -s http://example.org/update >/dev/null

If you set up a password-protected login, you will be required to allow anonymous updates, adding

allow_public_update_access=1

to your config.ini.
