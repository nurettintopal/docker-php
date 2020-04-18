FROM php:7.4-fpm-alpine3.11
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install packages
RUN apk --update add \
    nginx \
    supervisor \
    git \
    curl \
    unzip \
    nano \
    wget \
    gzip \
    openssl \
    zlib \
    bash \        
    php7-posix \
    php7-session \
    php7-mbstring \
    php7-json \
    php7-xml \
    php7-curl \
    php7-iconv \
    php7-dom \
    php7-phar \
    php7-openssl \
    php7-tokenizer \
    php7-xmlwriter \
    php7-simplexml \
    php7-ctype \
    php7-fileinfo \
    php7-zlib \
    php7-bcmath \
    php7-mysqlnd

ENV REDIS_VERSION 5.2.1
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-* /usr/src/php/ext/redis
RUN docker-php-ext-install redis

RUN docker-php-ext-install pdo mysqli pdo_mysql 
RUN docker-php-ext-install pcntl

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