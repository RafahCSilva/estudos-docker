#!/usr/bin/env bash
# Modified from https://github.com/ahmetb/kubectl-aliases

# kubectl
alias k='kubectl'

# apply
alias ka='kubectl apply --recursive -f'

# create
alias kc='kubectl create --recursive -f'

# delete
alias krm='kubectl delete -f'
alias krmf='kubectl delete --recursive -f'

# exec
alias kex='kubectl exec -i -t'
alias kexn='kubectl exec -i -t --namespace'

# logs
alias klo='kubectl logs -f'
alias klon='kubectl logs -f --namespace'

# get
alias kg='kubectl get'
alias kgowide='kubectl get -o=wide'
alias kgall='kubectl get --all-namespaces'
alias kgcm='kubectl get configmap'
alias kgdep='kubectl get deployment'
alias kging='kubectl get ingress'
alias kgno='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgsec='kubectl get secret'
alias kgsvc='kubectl get service'

# describe
alias kd='kubectl describe'
alias kdn='kubectl describe node'

# minikube
alias mk="minikube"
alias mksd="minikube start && minikube dashboard"

alias mk_reinstall_mac="minikube delete && minikube start --driver=hyperkit && minikube addons enable ingress"
alias mk_reinstall_win="minikube delete && minikube start --driver=hyperv --hyperv-virtual-switch=minikube && minikube addons enable ingress"

function update_kubeconfig() {
  rm -rf ~/.kube && \
  cp -a /mnt/c/Users/RafaelCardoso/.kube ~/.kube && \
  sed -i -e "s|C:|/mnt/c|g" -e "s|[\]|\x2f|g" ~/.kube/config
}
