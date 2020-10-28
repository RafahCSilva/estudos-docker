# Exercício 01 - Provisionar Caramelo/library_api em Kubernetes


## 1. APPLICATION

- Aplicação desenvolvida por [brunocaramelo/library_api](https://github.com/brunocaramelo/library_api)

````shell script
# Clone te Application for Example
git clone  --branch features/kubernets-integration https://github.com/brunocaramelo/library_api.git library_api
````


## 2. DOCKER

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
#  Pushing app (rafahcsilva/k8s_libraryapi-app:1.3.0)...
#  The push refers to repository [docker.io/rafahcsilva/k8s_libraryapi-app]
#  ...
#  1.3.0: digest: sha256:a1803d21c4ef2998ea46c16f054d6214d6b81446cd87501d60af4eafcf9a8325 size: 4922

# Publicado em https://hub.docker.com/r/rafahcsilva/k8s_libraryapi-app
````


## 3. KUBERNETES 

````shell script
# Crie os YMLs
cd ../Kubernetes

# Aplique eles
kubectl apply -f 00_namespace.yml
kubectl apply -f 01_mysql.yml
kubectl apply -f 02_redis.yml
#kubectl apply -f 03_app.yml
#kubectl apply -f 04_nginx.yml
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
kubectl get services -n=library-api
#  NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
#  kubernetes              ClusterIP      10.96.0.1       <none>        443/TCP        6h13m
#  mysql-service           ClusterIP      None            <none>        3306/TCP       17m
#  nginx-service           LoadBalancer   10.99.13.169    <pending>     80:31734/TCP   27m
#  redis-service           ClusterIP      10.103.103.25   <none>        6379/TCP       16m
#  testando01app-service   ClusterIP      10.97.186.47    <none>        9000/TCP       27m


# Rodando o Migrate:
# list all pods
kgowide pods -n=library-api
# copia o nome completo do app-deployment-*, e execute o comando abaixo
#   kubectl exec app-deployment-* -n=library-api -- php artisan migrate --seed
#   kubectl exec app-deployment-* -n=library-api -- php artisan migrate:refresh --seed --force
# ou Login no App-POD e execute
#   php artisan migrate --seed


# descubra o IP do service proxiado pelo minikube
minikube service nginx-service -n=library-api --url
# http://192.168.64.2:31734

# Acesse o app
# http://192.168.64.2:31734/api/v1/authors



# App e Nginx no mesmo POD
kubectl apply -f 05_webapp.yml
#  service/webapp-service created
#  deployment.apps/webapp-deployment created
#  configmap/webapp-app-conf created
#  configmap/webapp-nginxindex-map created
#  configmap/webapp-nginxconf-map created

# HPA
kubectl apply -f 05_webapp-hpa.yml

# Laravel Queue
kubectl apply -f 05_webapp-queue.yml
# Login in pod terminal:
#   php artisan queue:table
#   php artisan migrate
# curl http://libraryapi.test/api/v1/author/process/message?message=RAFAAAO


# Get URL
minikube service webapp-service -n=library-api --url


# Cron Jobs
kubectl apply -f 07_cronjobs.yaml
````


### 3.1. INGRESS ON MINIKUBE

````shell script
# Set up Ingress on Minikube with the NGINX Ingress Controller
# @ref https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

# Enable the Ingress controller
#  1. To enable the NGINX Ingress controller, run the following command:
minikube addons enable ingress

#  2. Verify that the NGINX Ingress controller is running (Note: This can take up to a minute.)
kubectl get pods -n kube-system

kubectl apply -f 06_webapp-ingress.yml
# ingress.networking.k8s.io/webapp-ingress created

# List Ingress
kubectl get ingress -n=library-api
#  NAME             CLASS    HOSTS             ADDRESS        PORTS   AGE
#  webapp-ingress   <none>   libraryapi.test   192.168.64.2   80      47s

# Add domain in /etc/hosts
sudo nano /etc/hosts
gsudo notepad C:\Windows\System32\Drivers\etc\hosts
#  192.168.64.2 libraryapi.test

# acesse http://libraryapi.test/api/v1/books
````


## 4. Kubernetes Templatized

````shell script
cd Kubernetes-templatized

# the kubetpl render template with variables in your evn and apply in kubectl
kubetpl render DEPLOYMENT_YAML -i ENV_FILE -x=$ | kubectl apply -f -

# tests in Kubernetes-templatized/gen.sh
````


## 5. Using a Local Docker Registry

- Configuring a Local Docker Registry
````shell script
cd local-registy
# config your certificates for SSL (required for kubernetes usage)
#   put files in ./data/certs
#   indicate files in `environment`:
#     `REGISTRY_HTTP_TLS_CERTIFICATE: /certs/SSL.crt`
#     `REGISTRY_HTTP_TLS_KEY: /certs/SSL.key`

# up the container
docker-compose up

# point the custom domain to your machine /etc/hosts
127.0.0.1 repo-registry-local.ftd.com.br
````

- Push Images to Local Registry
    - Add a tag in your Docker image in format `local-url:5000/project:version` to your last local image build
        - Run `docker tag IMAGE_HASH LOCAL_REGISTRY_URL:5000/IMAGE:VERSION`
            - for example `docker tag rafahcsilva/k8s_libraryapi-app:1.2.3 repo-registry-local.ftd.com.br:5000/k8s_libraryapi-app:1.2.3`
        - Or simply in `docker-compose.yaml` change `image: rafahcsilva/k8s_libraryapi-app:1.2.3` to `image: repo-registry-local.ftd.com.br:5000/k8s_libraryapi-app:1.2.3` and run `docker-compose build` 
    - Push the new tagged image `docker push repo-registry-local.ftd.com.br:5000/k8s_libraryapi-app:1.2.3`
    - Confirm receipt in registry `curl https://repo-registry-local.ftd.com.br:5000/v2/k8s_libraryapi-app/tags/list` for getting `{"name":"k8s_libraryapi-app","tags":["1.2.3"]}`

- Configuring Minikube to see your Local Registry
````shell script
# Inside the MinikuBe VM
# find the local IP used for `host.minikube.internal`
minikube ssh "cat /etc/hosts"
# > 192.168.0.179   host.minikube.internal

# point your Local URL to this IP 
minikube ssh "echo \"192.168.0.179   repo-registry-local.ftd.com.br\" | sudo tee -a /etc/hosts"
````

- Render Kubernetes templates with env to Local Registry and Apply
````shell script
cd Kubernetes-templatized
kubetpl \
  render ./template/05_webapp.yml \
  -i ./dev-localRegistry.env \
  -x=$ \
  | kubectl apply -f -
````
