/entrypoint/wait-for-it.sh mysql-service:3306 -t 90 -- echo "mysql-service is up"
php artisan migrate --force --seed &&
  docker-php-entrypoint php-fpm
