docker PHP on alpine linux [![Docker Pulls](https://img.shields.io/docker/pulls/nurettintopal/docker-php.svg)](https://hub.docker.com/r/nurettintopal/docker-php/)
==============================================

[Alpine Linux](https://www.alpinelinux.org/), [php](http://www.php.net/), [php-fpm](https://www.php-fpm.org/), [nginx](https://nginx.org/), [git](https://git-scm.com/), [composer](https://getcomposer.org/) for [Docker](https://www.docker.com/)

## branches & versions

|  Branch | PHP | Note |
|:-------|:---|:---|
| master  | 7.4 | stable |
| php-7.4 | 7.4 | stable |
| php-7.3 | 7.3 | stable |
| php-7.2 | 7.2 | stable - not updating anymore|
| php-7.1 | 7.1 | stable - not updating anymore|

## usage

build image:
```sh
$ docker build -t docker-php .
```

run container:
```sh
$ docker run -d -p 8080:8080 docker-php
```

open a browser and go to:
```sh
http://localhost:8080/
```

connect to container with ssh:
```sh
$ docker exec -it CONTAINER_ID sh
```

delete container:
```sh
$ docker rm -f CONTAINER_ID
```

## usage with docker-compose

```note
cooming soon...
``` 

## supported PHP extensions

 - php7-pcntl
 - php7-session
 - php7-mbstring
 - php7-json
 - php7-xml
 - php7-curl
 - php7-mysqli
 - php7-pdo
 - php7-pdo_mysql
 - php7-iconv
 - php7-dom
 - php7-phar
 - php7-openssl
 - php7-tokenizer
 - php7-xmlwriter
 - php7-simplexml
 - php7-ctype
 - php7-zlib
 - php7-redis

## contributing
```note
cooming soon...
``` 

## license
docker-php is open-sourced software licensed under the [MIT license](LICENSE).
