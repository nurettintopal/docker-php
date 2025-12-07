FROM alpine:3.23
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php85
RUN apk --update add php85
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
    php85-fpm \
    php85-posix \
    php85-session \
    php85-mbstring \
    php85-json \
    php85-xml \
    php85-curl \
    php85-iconv \
    php85-dom \
    php85-phar \
    php85-openssl \
    php85-tokenizer \
    php85-xmlwriter \
    php85-simplexml \
    php85-ctype \
    php85-fileinfo \
    php85-zlib \
    php85-bcmath \
    php85-mysqlnd \
    redis \
    php85-redis \
    php85-pdo \
    php85-mysqli \
    php85-pgsql \
    php85-pdo_mysql \
    php85-pdo_pgsql \
    php85-pcntl


RUN ln -s /usr/bin/php85 /usr/bin/php

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.9.2

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php85/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php85/conf.d/docker_custom.ini

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
