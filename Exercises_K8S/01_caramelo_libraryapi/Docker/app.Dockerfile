FROM php:7.2-fpm

# Install PHP extensions
RUN apt-get update -y -qq  \
        && \
    apt-get install -y -qq \
        zlib1g-dev \
        sqlite3 \
        libsqlite3-dev \
        libicu-dev \
        libpq-dev \
        libmcrypt-dev \
        unzip \
        rsyslog \
        && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
        && \
    docker-php-ext-install \
        intl \
        mbstring \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        pgsql \
        zip \
        opcache \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog
# RUN yes | pecl install xdebug

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# install phpunit
RUN composer global require phpunit/phpunit ^7.5 --no-progress --no-scripts --no-interaction && composer clearcache
ENV PATH /root/.composer/vendor/bin:$PATH

# Copy application
WORKDIR /var/www/html

COPY --chown=www-data:www-data ./library_api/application/ /var/www/html

# install application
RUN composer install --no-progress --no-scripts --no-interaction \
    && composer clearcache \
    && chown -R www-data:www-data vendor

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Entrypoint Scripts
# Wait For It
ADD --chown=www-data:www-data \
  https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  /entrypoint/wait-for-it.sh
RUN chmod +x /entrypoint/wait-for-it.sh
# App Entrypoint
COPY --chown=www-data:www-data ./Docker/entrypoint__app_entrypoint.sh /entrypoint/app_entrypoint.sh
RUN chmod +x /entrypoint/app_entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["sh", "/entrypoint/app_entrypoint.sh"]
