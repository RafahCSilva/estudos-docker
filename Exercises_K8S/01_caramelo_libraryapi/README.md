# Exercício 01 - Provisionar Caramelo/library_api em Kubernetes


## APPLICATION

- Aplicação desenvolvida por [brunocaramelo/library_api](https://github.com/brunocaramelo/library_api)

````shell script
# Clone te Application for Example
git clone  --branch features/kubernets-integration https://github.com/brunocaramelo/library_api.git library_api
````


## DOCKER - Building Images

````shell script
cd Docker
# Build all services
docker-compose build app

# check container is OK
docker-compose up -d
docker-compose exec app bash
docker-compose down


# Login Docker Hub
docker login

# Suba a Imagem para docker.io/rafahcsilva/testando01-app
docker-compose push app
#  Pushing app (rafahcsilva/k8s_libraryapi-app:1.0.0)...
#  The push refers to repository [docker.io/rafahcsilva/k8s_libraryapi-app]
#  ...
#  1.0.0: digest: sha256:2617e7c32a425ff2a83ddfc6bb85ea45bca929a7d69e9b691d7a0a04be51326b size: 3883

# Publicado em https://hub.docker.com/r/rafahcsilva/k8s_libraryapi-app
````


### KUBENETES 

````shell script
# Crie os YMLs
cd ../Kubernetes

# Aplique eles
kubectl apply -f mysql.yml
kubectl apply -f redis.yml
kubectl apply -f app.yml
kubectl apply -f nginx.yml
#  service/mysql-service created
#  deployment.apps/mysql-deployment created
#  persistentvolume/mysql-pv-volume created
#  persistentvolumeclaim/mysql-pv-claim created
#
#  service/redis-service created
#  deployment.apps/redis-deployment created
#
#  service/app-service created
#  deployment.apps/app-deployment created
#  configmap/app-conf created
#
#  service/nginx-service created
#  deployment.apps/nginx-deployment created
#  configmap/nginxindex-map created
#  configmap/nginxconf-map created


# veja se os services estao ok
kubectl get services
#  NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
#  kubernetes              ClusterIP      10.96.0.1       <none>        443/TCP        6h13m
#  mysql-service           ClusterIP      None            <none>        3306/TCP       17m
#  nginx-service           LoadBalancer   10.99.13.169    <pending>     80:31734/TCP   27m
#  redis-service           ClusterIP      10.103.103.25   <none>        6379/TCP       16m
#  testando01app-service   ClusterIP      10.97.186.47    <none>        9000/TCP       27m


# Login in App POD
php artisan migrate --seed


# descubra o IP do service proxiado pelo minikube
minikube service nginx-service --url
# http://192.168.64.2:31734

# Acesse o app
# http://192.168.64.2:31734/api/v1/authors
````
