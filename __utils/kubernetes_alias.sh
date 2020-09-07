#!/usr/bin/env bash
# Modified from https://github.com/ahmetb/kubectl-aliases

# kubectl
alias k='kubectl'

# apply
alias ka='kubectl apply --recursive -f'

# create
alias kc='kubectl create --recursive -f'

# delete
alias krm='kubectl delete'
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

# minikube
alias mk="minikube"
alias mksd="minikube start --driver=hyperkit && minikube dashboard"
