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

# Confirm PHP Version and Installed Extensions
RUN php -v
RUN php -m

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
ENV PATH /root/.composer/vendor/bin:$PATH

WORKDIR /var/www/html

# Copy Composer json
COPY --chown=www-data:www-data \
    ./library_api/application/composer.json \
    ./library_api/application/composer.lock \
    /var/www/html/

# Install dependencies
RUN composer check-platform-reqs \
    && composer install --no-progress --no-scripts --no-interaction --no-autoloader \
    && composer clearcache \
    && chown -R www-data:www-data vendor

# Copy application
COPY --chown=www-data:www-data \
    ./library_api/application/ \
    /var/www/html

# Build Autoload
RUN composer dump-autoload --no-scripts --optimize

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
CMD ["/entrypoint/app_entrypoint.sh"]
