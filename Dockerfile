FROM php:8.3.19-fpm-bookworm AS php
RUN \
    apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests libicu-dev libzip-dev \
    && docker-php-ext-install bcmath intl opcache pcntl pdo_mysql zip

FROM debian:12.10-slim

RUN \
    ln -snf /usr/share/zoneinfo/UTC /etc/localtime \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    supervisor \
    nginx-core \
    libicu-dev \
    libnginx-mod-http-headers-more-filter \
    libargon2-0-dev \
    libcurl4-openssl-dev \
    libzip-dev \
    libsodium-dev \
    libonig-dev \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

COPY --from=php /usr/local/etc/. /usr/local/etc
COPY --from=php /usr/local/bin/. /usr/local/bin
COPY --from=php /usr/local/sbin/. /usr/local/sbin
COPY --from=php /usr/local/lib/. /usr/local/lib
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY nginx.conf /etc/nginx/
COPY supervisord.conf /etc/supervisor/conf.d/
COPY php.ini /usr/local/etc/php/
COPY www.conf /usr/local/etc/php-fpm.d

ENV APP_DIR="/var/www/app"

WORKDIR $APP_DIR

COPY composer.* $APP_DIR/

RUN \
    composer install \
    --no-ansi \
    --no-cache \
    --no-dev \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --prefer-dist

COPY . $APP_DIR

RUN composer dump-autoload --optimize --no-scripts && php artisan filament:optimize

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]