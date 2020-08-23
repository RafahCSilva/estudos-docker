# Descomplicando o Kubernetes

## 1. O que é o Kubernetes e como instalar o Minikube

- [linuxtips.io/post/descomplicando-o-kubernetes-01](https://www.linuxtips.io/post/descomplicando-o-kubernetes-01)

`````shell script
# installing
brew install kubectl
kubectl version


# installing minikube
#   https://kubernetes.io/docs/tasks/tools/install-minikube/ 
#   https://github.com/kubernetes/minikube/releases/
brew install minikube
minikube version

# starting
minikube start
#  😄  minikube v1.12.3 on Darwin 10.15.6
#  ✨  Automatically selected the hyperkit driver
#  💾  Downloading driver docker-machine-driver-hyperkit:
#      > docker-machine-driver-hyperkit.sha256: 65 B / 65 B [---] 100.00% ? p/s 0s
#      > docker-machine-driver-hyperkit: 10.90 MiB / 10.90 MiB  100.00% 5.63 MiB p
#  🔑  The 'hyperkit' driver requires elevated permissions. The following commands will be executed:
#      $ sudo chown root:wheel /Users/rafaelcardoso/.minikube/bin/docker-machine-driver-hyperkit
#      $ sudo chmod u+s /Users/rafaelcardoso/.minikube/bin/docker-machine-driver-hyperkit
#  
#  💿  Downloading VM boot image ...
#      > minikube-v1.12.2.iso.sha256: 65 B / 65 B [-------------] 100.00% ? p/s 0s
#      > minikube-v1.12.2.iso: 173.73 MiB / 173.73 MiB [] 100.00% 6.13 MiB p/s 28s
#  👍  Starting control plane node minikube in cluster minikube
#  💾  Downloading Kubernetes v1.18.3 preload ...
#      > preloaded-images-k8s-v5-v1.18.3-docker-overlay2-amd64.tar.lz4: 510.91 MiB
#  🔥  Creating hyperkit VM (CPUs=2, Memory=4000MB, Disk=20000MB) ...
#  🐳  Preparing Kubernetes v1.18.3 on Docker 19.03.12 ...
#  🔎  Verifying Kubernetes components...
#  🌟  Enabled addons: default-storageclass, storage-provisioner
#  🏄  Done! kubectl is now configured to use "minikube"


# Para visualizar todos o node do minikube
kubectl get nodes
`````

`````shell script
kubectl run nginx --image nginx
kubectl get deployment
kubectl get nodes
# NAME       STATUS   ROLES    AGE   VERSION
# minikube   Ready    master   11m   v1.18.3
kubectl get pods
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          2m11s

`````

## 2. Como instalar e configurar um cluster Kubernetes

- [linuxtips.io/post/descomplicando-o-kubernetes-02](https://www.linuxtips.io/post/descomplicando-o-kubernetes-02)

`````shell script
# Installing Docker
curl -fsSL https://get.docker.com | bash

# Installing KUBERNETES
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl


# Disable SWAP
swapoff -a
# E comente a entrada referente a swap em seu arquivo fstab:
vim /etc/fstab


# Iniciando o Master
kubeadm init --apiserver-advertise-address $(hostname -i)
#  To start using your cluster, you need to run the following as a regular user:
#   mkdir -p $HOME/.kube
#   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#   sudo chown $(id -u):$(id -g) $HOME/.kube/config
#  ... 
#  kubeadm join --token 39c341.a3bc3c4dd49758d5 IP_DO_MASTER:6443 --discovery-token-ca-cert-hash sha256:37092

# instala o Weave Net (addon para criar VNet q conecta os containers de múltiplos hosts)
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


# Executa o comando JOIN nos servers nodes
kubeadm join --token 39c341.a3bc3c4dd49758d5 IP_DO_MASTER:6443 --discovery-token-ca-cert-hash sha256:37092
`````


## 3. Primeiros passos em nosso Cluster Kubernetes

- [linuxtips.io/post/descomplicando-o-kubernetes-03](https://www.linuxtips.io/post/descomplicando-o-kubernetes-03)

`````shell script
# lista os Nodes (servers slaves)
kubectl get nodes
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          2m11s


# carregando o auto complete do bash
source <(kubectl completion bash)
# ou do zsh
source <(kubectl completion zsh)
# no bash_profile
kubectl completion zsh > ~/.kube/completion.zsh.inc
printf "
  # Kubectl shell completion
  source '$HOME/.kube/completion.zsh.inc'
  " >> $HOME/.zshrc
source $HOME/.zshrc


# Inspecionando um Node
kubectl describe nodes

# listando os PODs
kubectl get pods
#  NAME    READY   STATUS    RESTARTS   AGE
#  nginx   1/1     Running   0          48m

# listando os PODs do namespace do k8s
kubectl get pods -n kube-system
#  NAME                               READY   STATUS    RESTARTS   AGE
#  coredns-66bff467f8-lbmnr           1/1     Running   0          59m
#  etcd-minikube                      1/1     Running   0          59m
#  kube-apiserver-minikube            1/1     Running   0          59m
#  kube-controller-manager-minikube   1/1     Running   0          59m
#  kube-proxy-gphdz                   1/1     Running   0          59m
#  kube-scheduler-minikube            1/1     Running   0          59m
#  storage-provisioner                1/1     Running   0          59m

# Inspecionando um POD do ns do k8s
kubectl describe pod kube-apiserver-minikube -n kube-system

# listando os IP dos pods
kubectl get pods -n kube-system -o wide
#  NAME                               READY   STATUS    RESTARTS   AGE   IP             NODE       NOMINATED NODE   READINESS GATES
#  coredns-66bff467f8-lbmnr           1/1     Running   0          63m   172.17.0.2     minikube   <none>           <none>
#  etcd-minikube                      1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>
#  kube-apiserver-minikube            1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>
#  kube-controller-manager-minikube   1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>
#  kube-proxy-gphdz                   1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>
#  kube-scheduler-minikube            1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>
#  storage-provisioner                1/1     Running   0          63m   192.168.64.2   minikube   <none>           <none>

# Rodando o primeiro pod
kubectl run meu-nginx --image nginx
#  pod/meu-nginx created
kubectl get pods -o wide 
kubectl describe pod meu-nginx
kubectl describe deployment meu-nginx

# Aumentando a quantidade de replicas
kubectl scale deployment meu-nginx --replicas=10

# removendo um POD
kubectl delete pod meu-nginx
#  pod "meu-nginx" deleted
`````


## 4. Como configurar um cluster KUBERNETES sem o DOCKER


## 5. Como criar services no Kubernetes

`````shell script
# suba o nginx na porta 80
kubectl run meu-nginx --image nginx --port 80
# pod/meu-nginx created

# Exponha a porta o servico
kubectl expose deployment meu-nginx
# service/meu-nginx exposed

# Liste os servicos
kubectl get services
#  NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
#  kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   3h1m
#  meu-nginx    ClusterIP   10.100.107.227   <none>        80/TCP    71s

kubectl describe services meu-nginx
#  Name:              meu-nginx
#  Namespace:         default
#  Labels:            run=meu-nginx
#  Annotations:       <none>
#  Selector:          run=meu-nginx
#  Type:              ClusterIP
#  IP:                10.100.107.227
#  Port:              <unset>  80/TCP
#  TargetPort:        80/TCP
#  Endpoints:         172.17.0.3:80
#  Session Affinity:  None
#  Events:            <none>

# deletando um service
kubectl delete service meu-nginx


kubectl expose pod meu-nginx --type NodePort
# service/meu-nginx exposed
`````
