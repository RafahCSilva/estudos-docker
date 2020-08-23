# Docker - Volumes e Networking

## Introdução


## Tipos de volumes Docker

- montagem no fs dentro do container
- 3 tipos de Volumes:
    - `bind`: fs do host compartilhado (espelhado)
    - `volume`: fs privado no dados do docker em execução no host
        - melhor para compartilhar arquivos inter-containers
    - `tpmfs`: persistido em memory
    - 
    - 

## Trabalhando com volumes no Docker Parte 1

`````shell script
# comando para montar volume em um container `-v`
docker run -d --name devteste -v myvol:/app nginx

# inspecione o container, e veja no objetos Mount os volumes
# ao remover o container, o volume nao é deletado junto

# listar os volumes
docker volume ls

# no Docker-Compose tem q definir explicitamente na raiz do objeto os volumes desejados 
`````


## Trabalhando com volumes no Docker Parte 2

- Quando é feito a primeira montagem do volume, os arquivos do container é copiado para o fs privado, e assim é montado no container, para que as proximas montagem tbm obterão estes primeiros arquivos.


## Trabalhando com volumes somente leitura

- no docker-composer.yml, no `volumes` colocar `read_only: true` no item


## Trabalhando com volumes de ligação


- bind é a montagem do fs do host dentro do container, por exemplo compartilhar código da aplicação


## Visão geral das redes no Docker

- Tipos de NetWorks:
    - `bridge`: encaminha todo o trafego
        - rede padrão qdo não é especificado no container
    - `host`: ganha a faixa do IP do host, removendo o isolamento 
    - `overlay`: para conectar custers
    - `mecvlan`: emula um dispositivo fisico, para algo legado q conecta em dispositivo fisico
    
    
## Trabalhando com redes bridge parte 1

`````shell script
# para listar as network
docker network ls

# criando uma net
docker network create --drive bridge NAME-net

# rodando um container com esse nova net
docker run -d --name nginx03 --network NAME-net nginx:alpine

# via docker-composer se cria novos sempre, entao apra usa um criado externamente  
# no docker-composer.yml, no `networks` colocar `external: true`  
`````


## Trabalhando com redes bridge parte 2

- nas redes bridge, o docker usa o nome do servico como hostname, para nao precisarmod descobrir o IP de outro container


## Trabalhando com redes do modo host

`````shell script
# ja existe um network padrão chamado `host`

# rodando um container em net host
docker run -d --name nginx04 --network host nginx:alpine
`````


## Conclusão
