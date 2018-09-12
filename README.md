docker PHP on alpine linux
==============================================

[Alpine Linux](https://www.alpinelinux.org/), [php](http://www.php.net/), [php-fpm](https://www.php-fpm.org/), [nginx](https://nginx.org/), [git](https://git-scm.com/), [composer](https://getcomposer.org/) for [Docker](https://www.docker.com/)

# branches & versions

|  Branch | PHP | Note |
|:-------|:---|:---|
| master  | 7.2 | stable |
| php-7.2 | 7.2 | stable |
| php-7.1 | 7.1 | stable |

# usage

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
$ docker exec -it XXXXXX sh
```

delete container:
```sh
$ docker rm -f XXXXXX
```


# usage with docker-swarm

```note
cooming soon...
``` 


# detail
```note
cooming soon...
``` 

# contributing
```note
cooming soon...
``` 

# license
The docker-php is open-sourced software licensed
