# Avançando com DockerFile e Docker-Compose


## Dockerfile

- [DockerFile Reference](https://docs.docker.com/engine/reference/builder/#from)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

- `FROM`: `FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]`
    - imagem base. Use preferencialmente imagem de referência (user "_" do docker hub), como OS (ubuntu, debian, alpline, ..) somado ao seu RunTime (PHP, node, python,...)
- `RUN`:
    - `RUN <command>`: comando para shell e rodado no shell pelo comando `/bin/sh -c "<command>"` (no Windows: `cmd /S /C`)
    - `RUN ["executable", "param1", "param2"]`: array de json, executa de modo direto (`executable param1 param2`) sem ser um subcommand
- `WORKDIR`: `WORKDIR /path/to/workdir`
    - muda para este diretorio, para os RUNs seguintes, nao precisando usar o path absoluto para tudo 
- `COPY`: `COPY [--chown=<user>:<group>] <src> <dest>`
    - copiar arquivos do Host para o Container
    - exemplo `COPY ../src /var/www/html`
        - `src`: path relativo ao local do Dockerfile, permite glob (`file-*.zip`), diretorio serão copiados com seus metadados
        - `dest`: path do WORKDIR atual, cria os diretórios faltantes no caminho, se o path não terminar com `/` será considerado um arquivo normal
- `ADD`: `ADD [--chown=<user>:<group>] <src>... <dest>`
    - semelhante ao COPY, mas permite q o src seja links publicos (se tiver altenticação, então terá q usar `RUN curl`)
    - Atenção, após o primeiro uso do ADD, invalidará o cache das próximas instruções.
    - diferenças no `src` em relação ao COPY: 
        - Se URL e dest finalizando sem `/`, o arquivo será salvo como `<dest>`. 
        - Se URL e dest finalizando com `/`, o arquivo será salvo como `<dest>/<filename_from_url>`
        - Se for um arquivo local em `tar`, então será descompactado (URL não deixa descompactar)
- `ENV`: `ENV <key> <value>` ou `ENV <key>=<value>`
    - usando `=` pode definir varias envs (`ENV k1=v1 k2=v2...`)
    - use`docker inspect` par ver os valores
    - altere os valores em RunTime com `docker run --env <key>=<value>`
    - Env somente para um comando use `RUN <key>=<value> <command>`
- `ENTRYPOINT`: 
    - exec form: `ENTRYPOINT ["executable", "param1", "param2"]`
    - shell form: `ENTRYPOINT command param1 param2`
    - Configura para seu conteiner rodar como um executável encapsulado pelo container
    - se usar o sheel form (`/bin/sh -c...`) nao poderá ser passado SIGNALS, por nao ser `PID 1`
    - para sobreescrever o entrypoint user o argumento `--entrypoint` do  `docker run`
- `CMD`:
    - `CMD ["executable","param1","param2"]` (exec form, this is the preferred form)
    - `CMD ["param1","param2"]` (as default parameters to ENTRYPOINT)
    - `CMD command param1 param2` (shell form)
    - somente poderá ter um CMD, e valerá o ultimo
    - junto com o ENTRYPOINT, o CMD serve como argumentos defaults do ENTRYPOINT
- `EXPOSE`: `EXPOSE <port> [<port>/<protocol>...]`
    - qual porta o conteiner pode escutar
    - o protocolo default é TCP
- `USER`: `USER <user>[:<group>]`ou `USER <UID>[:<GID>]`
    - usuario q rodará o container, ou os RUN/CMD/ENTRYPOINT seguintes do DockerFile 
    - se nao definido, sempre erá o root



## Docker-Compose

- [docs.docker.com/compose](https://docs.docker.com/compose/compose-file/)
- Serve para fazer composição de containers
- substitui todos os comandos manuais que usa inúmeros args para Build&Run, já que tudo é definido em um YAML 

