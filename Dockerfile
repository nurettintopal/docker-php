FROM alpine:3.19
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php82
RUN apk --update add php82
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
    php82-fpm \
    php82-posix \
    php82-session \
    php82-mbstring \
    php82-json \
    php82-xml \
    php82-curl \
    php82-iconv \
    php82-dom \
    php82-phar \
    php82-openssl \
    php82-tokenizer \
    php82-xmlwriter \
    php82-simplexml \
    php82-ctype \
    php82-fileinfo \
    php82-zlib \
    php82-bcmath \
    php82-mysqlnd \
    redis \
    php82-redis \
    php82-pdo \
    php82-mysqli \
    php82-pdo_mysql \
    php82-pcntl

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.5.4

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php82/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php82/conf.d/docker_custom.ini

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
