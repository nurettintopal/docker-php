FROM alpine:3.14
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php8
RUN apk --update add php8
RUN ln -s /usr/bin/php8 /usr/bin/php

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
    php8-fpm \
    php8-posix \
    php8-session \
    php8-mbstring \
    php8-json \
    php8-xml \
    php8-curl \
    php8-iconv \
    php8-dom \
    php8-phar \
    php8-openssl \
    php8-tokenizer \
    php8-xmlwriter \
    php8-simplexml \
    php8-ctype \
    php8-fileinfo \
    php8-zlib \
    php8-bcmath \
    php8-mysqlnd \
    redis \
    php8-redis \
    php8-pdo \
    php8-mysqli \
    php8-pdo_mysql \
    php8-pcntl

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.0.8

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php8/conf.d/docker_custom.ini

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
