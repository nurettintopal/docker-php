FROM alpine:3.17
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php81
RUN apk --update add php81
#RUN ls /usr/bin
#RUN php -v
#RUN ln -s /usr/bin/php8 /usr/bin/php

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
    php81-fpm \
    php81-posix \
    php81-session \
    php81-mbstring \
    php81-json \
    php81-xml \
    php81-curl \
    php81-iconv \
    php81-dom \
    php81-phar \
    php81-openssl \
    php81-tokenizer \
    php81-xmlwriter \
    php81-simplexml \
    php81-ctype \
    php81-fileinfo \
    php81-zlib \
    php81-bcmath \
    php81-mysqlnd \
    redis \
    php81-redis \
    php81-pdo \
    php81-mysqli \
    php81-pdo_mysql \
    php81-pcntl

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.5.4

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php81/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php81/conf.d/docker_custom.ini

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
