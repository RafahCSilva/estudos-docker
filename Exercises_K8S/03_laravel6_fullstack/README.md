# Exercício 03: Provisionar um Laravel v6.x FullStack

## A Aplicação

````shell script
# Install fresh app
composer create-project --prefer-dist laravel/laravel src "6.*"

# install UI
composer require laravel/ui:^1.0 --dev
php artisan ui vue --auth

````

## Docker

````shell script
docker-compose build 
docker-compose push app web
#  Pushing app (rafahcsilva/k8s_laravel6fs-app:1.0.0)...
#  The push refers to repository [docker.io/rafahcsilva/k8s_laravel6fs-app]
#  1.0.0: digest: sha256:7a55804d286c377d53be8423e7f6eed7494461a3d498ab9770608e67420e558a size: 4713
#  
#  Pushing web (rafahcsilva/k8s_laravel6fs-web:1.0.0)...
#  The push refers to repository [docker.io/rafahcsilva/k8s_laravel6fs-web]
#  1.0.0: digest: sha256:21f32d9c3ec59dec595e798b7a2b46ed44c09a5fef1ac2c55e9e853e9c630724 size: 1777
````
