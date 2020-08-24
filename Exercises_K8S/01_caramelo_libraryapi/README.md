# Exercício 01 - Provisionar Caramelo/library_api em Kubernetes


## APPLICATION

- Aplicação desenvolvida por [brunocaramelo/library_api](https://github.com/brunocaramelo/library_api)


````shell script
git clone  --branch features/kubernets-integration https://github.com/brunocaramelo/library_api.git
cd library_api

# edit /library_api/docker-compose.yml, in php service
#    from => image: laravel:php-fpm
#    to   => image: rafahcsilva/testando01-app:v2
sed -i '' 's/laravel:php-fpm/rafahcsilva\/testando01-app:v2/' docker-compose.yml
````


## DOCKER - Building Images

````shell script
# Build all services
docker-compose build

# Login Docker Hub
docker login

# Suba a Imagem para docker.io/rafahcsilva/testando01-app
docker-compose push php
#  Pushing php (rafahcsilva/testando01-app:v1)...
#  The push refers to repository [docker.io/rafahcsilva/testando01-app]
#  2b09d1069803: Pushed
#  5c217b44c19f: Pushed
#  df49a05a597e: Pushed
#  3cafc807cf23: Pushed
#  30918c8cdb61: Pushed
#  8bd7d0089c63: Pushed
#  965dd27573b5: Mounted from library/php
#  9c8e7c68045e: Mounted from library/php
#  3a49ca505d36: Mounted from library/php
#  2d59274138dc: Mounted from library/php
#  9628bb7e13e0: Mounted from library/php
#  c0ff421a6f25: Mounted from library/php
#  2ecbf8178259: Mounted from library/php
#  65bff11b305b: Mounted from library/php
#  de5ed450c2e9: Mounted from library/php
#  8bf7a47284aa: Mounted from library/php
#  d0f104dc0a1f: Mounted from library/php
#  v1: digest: sha256:f1cc2473c58fff00a460851c1721e0246c210beff3fc8aad7f37b6bceb40e79f size: 3882

# Publicado em https://hub.docker.com/r/rafahcsilva/testando01-app
````


### KUBENETES 

````shell script
# Crie os YMLs
cd ../kubernetes

# Aplique eles
kubectl apply -f mysql.yml
kubectl apply -f redis.yml
kubectl apply -f app.yml
kubectl apply -f nginx.yml

# veja se os services estao ok
kubectl get services
#  NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
#  kubernetes              ClusterIP      10.96.0.1       <none>        443/TCP        6h13m
#  mysql-service           ClusterIP      None            <none>        3306/TCP       17m
#  nginx-service           LoadBalancer   10.99.13.169    <pending>     80:31734/TCP   27m
#  redis-service           ClusterIP      10.103.103.25   <none>        6379/TCP       16m
#  testando01app-service   ClusterIP      10.97.186.47    <none>        9000/TCP       27m


# Login in App POD
apt-get install unzip
composer install
php artisan migrate --seed


# descubra o IP do service proxiado pelo minikube
minikube service nginx-service --url
# http://192.168.64.2:31734

# Acesse o app
# http://192.168.64.2:31734/api/v1/authors
````
