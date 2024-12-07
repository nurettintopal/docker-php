FROM alpine:3.21.0
LABEL maintainer="Nurettin Topal <nurettintopal@gmail.com>"

# Install php84
RUN apk --update add php84
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
    php84-fpm \
    php84-posix \
    php84-session \
    php84-mbstring \
    php84-json \
    php84-xml \
    php84-curl \
    php84-iconv \
    php84-dom \
    php84-phar \
    php84-openssl \
    php84-tokenizer \
    php84-xmlwriter \
    php84-simplexml \
    php84-ctype \
    php84-fileinfo \
    php84-zlib \
    php84-bcmath \
    php84-mysqlnd \
    redis \
    php84-redis \
    php84-pdo \
    php84-mysqli \
    php84-pdo_mysql \
    php84-pcntl


RUN ln -s /usr/bin/php84 /usr/bin/php

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=2.8.3

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php84/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php84/conf.d/docker_custom.ini

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
