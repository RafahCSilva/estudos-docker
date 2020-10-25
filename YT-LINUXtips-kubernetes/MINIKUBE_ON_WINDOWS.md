# MINIKUBE on Windows

## Installing

````shell script
# install gsudo - a sudo for Windows
choco install gsudo -y
:: update Path environment variable
refreshenv

# install docker + kubernetes + minikube
gsudo choco install docker-desktop kubernetes-cli minikube -y
````

## Configuring

Run minikube always in Terminal as ADMIN. 

E com essa config em HyperV, não terá problemas com o Ingress (sem as limitações se fosse rodar em Docker, ou VirtualBox).

````shell script
minikube delete
# Open Hyper-V Manager, click on Virtual Switch Manager, Create New Virtual Network Switch, Select external type, naming the switch to `minikube`, and OK. 
minikube start --driver=hyperv --hyperv-virtual-switch=minikube
minikube dashboard
minikube addons enable ingress --alsologtostderr
````

### Se tiver problema ao fazer pull da image

````shell script
# check o link da imagem
kubectl -n kube-system edit deployment ingress-nginx-controller
# faca pull dela
minikube ssh
docker pull us.gcr.io/k8s-artifacts-prod/ingress-nginx/controller:v0.34.1
minikube addons enable ingress --alsologtostderr
````

## Docker and Kubernetes running within the WSL2

Add function in you .bashrc:

````shell script
# docker-machine $PATH
PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin"
# add aliases
source ~/.myaliases/docker_alias.sh
[ -f kubectl ] && source <(kubectl completion zsh)
source ~/.myaliases/kubernetes_alias.sh

# or only
function update_kubeconfig() {
  rm -rf ~/.kube && \
  cp -a /mnt/c/Users/RafaelCardoso/.kube ~/.kube && \
  sed -i -e "s|C:|/mnt/c|g" -e "s|[\]|\x2f|g" ~/.kube/config
}

# and run after start minikube
update_kubeconfig
````
