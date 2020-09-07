#!/usr/bin/env bash
# Modified from https://gist.github.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb

############################################################################
#                                                                          #
#               ------- Useful Docker Aliases --------                     #
#     # Usage:                                                             #
#     dc             : docker-compose                                      #
#     dcu            : docker-compose up -d                                #
#     dcd            : docker-compose down                                 #
#     dcr            : docker-compose run                                  #
#     dex <container>: execute a bash shell inside the RUNNING <container> #
#     di <container> : docker inspect <container>                          #
#     dim            : docker images                                       #
#     dip            : IP addresses of all running containers              #
#     dl <container> : docker logs -f <container>                          #
#     dnames         : names of all running containers                     #
#     dps            : docker ps                                           #
#     dpsa           : docker ps -a                                        #
#     drmc           : remove all exited containers                        #
#     drmid          : remove all dangling images                          #
#     drun <image>   : execute a bash shell in NEW container from <image>  #
#     dsr <container>: stop then remove <container>                        #
#                                                                          #
############################################################################

# DOCKER
function drun() {
  docker run -it "$@"
}
function drund() {
  docker run -d "$@"
}
function dex() {
  docker exec -it "$1" "${2:-bash}"
}
function ds() {
  docker stop "$@"
}
function drm() {
  docker rm "$@"
}
function dsr() {
  docker stop "$@"
  docker rm "$@"
}
function di-fn() {
  docker inspect "$@"
}
alias dimg="docker images"
function dnames() {
  for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
    docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
  done
}
function dip() {
  echo "IP addresses of all named running containers"
  for DOC in $(dnames); do
    IP=$(docker inspect "$DOC" | grep -m2 IPAddress | cut -d '"' -f 4 | tr -d "\n")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo "$OUT" | column -t
}
function dlog() {
  docker logs -f "$@"
}
alias dps="docker ps"
alias dpsa="docker ps -a"
function drm_all() {
  docker rm $(docker ps --all -q -f status=exited)
}
function dsr_all() {
  docker stop $(docker ps --all -q)
  drm_all
}
function drmi_all() {
  imgs=$(docker images -q -f dangling=true)
  [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}
alias dprune="docker system prune --all"

# DOCKER-COMPOSE
function dc() {
  docker-compose "$@"
}
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
function dcr() {
  docker-compose run "$@"
}
function dcb() {
  docker-compose build "$@"
}
