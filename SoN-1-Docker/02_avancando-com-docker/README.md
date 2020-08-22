# Avançando com Docker

## Introdução

## Criando um cluster de Docker Swarm

- Swarm = Enxame
- clusters de containers

`````shell script
# inicializa o swarm
docker swarm init
# Swarm initialized: current node (0fv0ncmy8g3v4m3hk1p4ou5j7) is now a manager.
# To add a worker to this swarm, run the following command:
#     docker swarm join --token SWMTKN-1-4no6ilogdi2yhqxiw1as65ht1suwr6q3dhd2intan1wj2ogokg-5x0y1lzcf13fb2ui96l7sy7jm 192.168.65.3:2377
# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

# se perguntar por interface de rede, basta indicar qual na reexecução do comando.

# com o comando acima, este docker é o Gerenciador (master)
`````

## Configurando nós

`````shell script
# Criar outras VMs com Docker dentro delas
# Se em Docker-Machine (toolbox), faca o toolbox criar outras VMs de docker
docker-machine create --drive virtualbox myvm1
docker-machine create --drive virtualbox myvm2
docker-machine ls

# e conecte este Docker como um Nó para o Gerenciador
docker-machine ssh myvm1 "docker swarm join --token SWMTKN-1-4no6ilogdi2yhqxiw1as65ht1suwr6q3dhd2intan1wj2ogokg-5x0y1lzcf13fb2ui96l7sy7jm 192.168.65.3:2377"
# This node joined a swarn  a worker
`````


## Implantando aplicativo em cluster swarm

`````shell script
# faz um `docker-composer.yml`, com o objeto `deploy`

# Deploy:
docker stack deploy -c docker-composer.yml APP_NAME
`````


## Validando implantação

`````shell script
# PS
docker service ls
`````

## Escalando aplicativo

`````shell script
# Edita o docker-composer.yml
# por exemplo, aumentando o numero de replicas
# e bastará fazer o deploy novamente, que o docker ira atualizar os serviços sem baixar a pilha
docker stack deploy -c docker-composer.yml APP_NAME
`````


## Atualizando pilha



## Validando implantação do visualizador



## Configurando volume persistente



## Visualizando logs



## Criando um cluster de Docker Swarm na Digital Ocean



## Implantando aplicativo conteinerizado na Digital Ocean



