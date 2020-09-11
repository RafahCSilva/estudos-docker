/entrypoint/wait-for-it.sh mysql-service:3306 -t 90 -- echo "mysql-service is up"
php artisan config:cache
php artisan migrate
docker-php-entrypoint php-fpm
