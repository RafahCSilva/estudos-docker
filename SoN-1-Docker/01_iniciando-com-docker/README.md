# Iniciando com Docker

## Introdução

- [docker.com](https://www.docker.com/)
- Framework de container

## Entendendo contêineres

- [What is a Container?](https://www.docker.com/resources/what-container)


## Instalando Docker no Windows ou  Linux

- [Get Docker](https://docs.docker.com/get-docker/)


## Primeiros passos

````shell script
# Hello World
docker run hello-world
# Unable to find image 'hello-world:latest' locally
# latest: Pulling from library/hello-world
# 0e03bdcc26d7: Pull complete
# Digest: sha256:7f0a9f93b4aa3022c3a4c147a449bf11e0941a1fd0bf4a8e6c9408b2600777c5
# Status: Downloaded newer image for hello-world:latest
# 
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
# 
# To generate this message, Docker took the following steps:
#  1. The Docker client contacted the Docker daemon.
#  2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
#     (amd64)
#  3. The Docker daemon created a new container from that image which runs the
#     executable that produces the output you are currently reading.
#  4. The Docker daemon streamed that output to the Docker client, which sent it
#     to your terminal.
# 
# To try something more ambitious, you can run an Ubuntu container with:
#  $ docker run -it ubuntu bash
# 
# Share images, automate workflows, and more with a free Docker ID:
#  https://hub.docker.com/
# 
# For more examples and ideas, visit:
#  https://docs.docker.com/get-started/



# Rodando Ubuntu
docker run -it ubuntu bash
# Unable to find image 'ubuntu:latest' locally
# latest: Pulling from library/ubuntu
# 3ff22d22a855: Pull complete
# e7cb79d19722: Pull complete
# 323d0d660b6a: Pull complete
# b7f616834fd0: Pull complete
# Digest: sha256:5d1d5407f353843ecf8b16524bc5565aa332e9e6a1297c73a92d3e754b8a636d
# Status: Downloaded newer image for ubuntu:latest
# root@00dfc2cbddd4:/# uname -a
# Linux 00dfc2cbddd4 4.19.76-linuxkit #1 SMP Tue May 26 11:42:35 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
# root@00dfc2cbddd4:/# cat /etc/lsb-release
# DISTRIB_ID=Ubuntu
# DISTRIB_RELEASE=20.04
# DISTRIB_CODENAME=focal
# DISTRIB_DESCRIPTION="Ubuntu 20.04 LTS"



# Listar Processos
docker ps
# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
docker ps -a
# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS  NAMES
# 00dfc2cbddd4        ubuntu              "bash"              4 minutes ago       Exited (0) 2 minutes ago          practical_edison
# e05d09b1fd03        hello-world         "/hello"            6 minutes ago       Exited (0) 6 minutes ago          reverent_lederberg


# Parar Container
docker stop 44154588f895

# Remover Container
docker rm 44154588f895


# Listar Imagens
docker images
# REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
# ubuntu              latest              1e4467b07108        3 weeks ago         73.9MB
# hello-world         latest              bf756fb1ae65        7 months ago        13.3kB


# Remover Imagens
docker rmi bf756fb1ae65

````


## Criando contêiner do Nginx e expondo portas


````shell script
docker run nginx
# DockerHub: https://hub.docker.com/_/nginx


# mapeando a porta 80 do container para a 8080 do host
docker run -d -p 8080:80 nginx
# acesse http://localhost:8080

# com um nome
docker run -d --name NOME_DAHORA -p 8080:80 nginx
````



## Executando comandos dentro de contêineres

````shell script
docker exec -it NOME_DAHORA /bin/bash
````



## Criando uma imagem a partir de um contêiner

````shell script
# entre no containter do EXEC
# edite algo dentro
echo "<h1>dahora</h1>" > /usr/share/nginx/html/index.html

# Crie uma IMAGEM apartir do estado do container
docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
docker commit NOME_DAHORA nginx-dahora:v1
#sha256:f76bc252c7fabebf442198f4667f6ba5a7ebfff53d7cfc0e7dbb6ef867c97cf1
docker imgagems
# REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
# nginx-dahora        v1                  f76bc252c7fa        7 seconds ago       133MB
# nginx               latest              4bb46517cac3        5 days ago          133MB
# ubuntu              latest              1e4467b07108        3 weeks ago         73.9MB
# hello-world         latest              bf756fb1ae65        7 months ago        13.3kB

# Crie um container apartir da nova image
docker run -d --name OUTRO_DAHORA -p 8082:80 nginx-dahora:v1
# acesse http://localhost:8082
````

## Entendendo volumes

````shell script
# cria um volume data (directorio interno de dados dos ) e monta ele dentro do container
# o docker 
docker run -it -v /data --name teste_volume -p 8082:80 nginx /bin/bash
docker inspect teste_volume
# verifique o "Mounts"
````

## Compartilhando volumes

````shell script
# mapeado um volume do host para o container (ABSOLUTE PATHS)
docker run -d -v /Users/rafaelcardoso/www/estudos-docker/SoN-1-Docker/01_iniciando-com-docker/data:/usr/share/nginx/html --name teste_volume_compartilhado -p 8083:80 nginx
docker exec -it teste_volume_compartilhado /bin/bash
# acesse http://localhost:8083/hello.html
# edite ./data/hello.html no host e atualize a pagina

# no container, crie um arquivo e verifique se criou no host
echo "guest to host" > /usr/share/nginx/html/teste.txt


# criando um novo container reutilizando os volumes de outro
docker run -d --volumes-from teste_volume_compartilhado --name outro_volume_compartilhado -p 8084:80 nginx
# acesse http://localhost:8084/hello.html
````


## Linkando contêineres na prática


````shell script
# rodando um container de MySQL https://hub.docker.com/_/mysql
docker run --name dbserver -e MYSQL_ROOT_PASSWORD=segredo -e MYSQL_DATABASE=db_dahora -d mysql:5.7


# WordPress linkado ao db (compartilhado os ENV e a comunicacao do container DB com este container)
# https://hub.docker.com/_/wordpress
docker run --name app_wp --link dbserver:mysql -d -p 8088:80 wordpress
# acesse http://localhost:8088
````


## Dockerfile

````shell script
# Edite o Dockerfile
# Build a imagem
docker build -t rafahcsilva/nginx .

docker image
# REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
# rafahcsilva/nginx   latest              0a387f8d550c        12 seconds ago       156MB

docker run -d -p 8001:8080 rafahcsilva/nginx
# acesse http://localhost:8001
````


## Trabalhando com Docker-Compose

Docker-Compose facilita a configuração para rodar os container.

````shell script
# subindo os container (build se necesario)
docker-compose up -d
docker-compose down
````
