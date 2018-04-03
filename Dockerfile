FROM alpine:3.7
MAINTAINER Nurettin Topal <nurettintopal@gmail.com>

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.7/community' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.7/main' >> /etc/apk/repositories
RUN echo 'http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories
RUN echo 'http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN echo 'http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories

#set timezone => Turkey - Istanbul
#https://wiki.alpinelinux.org/wiki/Setting_the_timezone
RUN apk --update add tzdata
RUN cp /usr/share/zoneinfo/Turkey /etc/localtime
RUN echo "Turkey" >  /etc/timezone
RUN apk del tzdata
RUN date

RUN apk update && apk upgrade

# Install packages
RUN apk --update add \
    php7 \
    php7-fpm \
    nginx \
    supervisor \
    git \
    curl \
    unzip \
    gzip \
    nano \
    wget \
    php7-pcntl \
    php7-session \
    php7-gd \
    php7-mbstring \
    php7-json \
    php7-xml \
    php7-curl \
    php7-mysqli \
    php7-pdo \
    php7-pdo_mysql \
    php7-iconv \
    php7-dom \
    php7-opcache \
    php7-phar \
    openssl \
    php7-openssl \
    php7-tokenizer \
    php7-xmlwriter \
    php7-simplexml \
    php7-ctype \
    zlib \
    php7-zlib \
    php7-ldap \
    bash

RUN apk update && apk upgrade
RUN apk --update add zip php7-redis

# Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# prestissimo - composer parallel install plugin
RUN composer global require "hirak/prestissimo:^0.3"

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php7/conf.d/docker_custom.ini

# copy default nginx conf
COPY config/default-nginx /etc/nginx/sites-available/default
WORKDIR /etc/nginx/sites-enabled/
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN rm -rf /var/www
RUN mkdir -p /var/www
WORKDIR /var/www
COPY src/ /var/www/

RUN rm -rf /var/cache/apk
RUN rm -rf /root/.composer/cache

EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
