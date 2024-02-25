FROM alpine:3.19
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php83
RUN apk --update add php83
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
    php83-fpm \
    php83-posix \
    php83-session \
    php83-mbstring \
    php83-json \
    php83-xml \
    php83-curl \
    php83-iconv \
    php83-dom \
    php83-phar \
    php83-openssl \
    php83-tokenizer \
    php83-xmlwriter \
    php83-simplexml \
    php83-ctype \
    php83-fileinfo \
    php83-zlib \
    php83-bcmath \
    php83-mysqlnd \
    redis \
    php83-redis \
    php83-pdo \
    php83-mysqli \
    php83-pdo_mysql \
    php83-pcntl


RUN ln -s /usr/bin/php83 /usr/bin/php

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.7.1

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php83/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php83/conf.d/docker_custom.ini

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
