minikube start --driver=virtualbox --cpus=2 --memory=8gb --disk-size=40gb
kubectl get componentstatuses
kubectl cluster-info
kubectl exec -it hello bash
kubectl logs hello
kubectl port-forward hello 1234:80
kubectl label node k8s-node2 node-role.kubernetes.io/worker= #add label node
kubectl label node k8s-node2 node-role.kubernetes.io/worker- #delete label
#####################################################
#создание нового токена для присоединения нод
#####################################################
kubeadm token create #на мастере
kubeadm token list
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
добавляем ноду с новыми токенами
#######################################################

#######################################################
# установка дашборда для кубернетеса
#######################################################
mkdir $HOME/certs
cd $HOME/certs
openssl genrsa -out dashboard.key 2048
openssl rsa -in dashboard.key -out dashboard.key
openssl req -sha256 -new -key dashboard.key -out dashboard.csr -subj '/CN=dashboard'
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.csr
kubectl -n kube-system create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs
kubectl -n kubernetes-dashboard edit service kubernetes-dashboard #type изменить на LoadBalancer
kubectl -n kubernetes-dashboard describe secrets $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') # узнать токен для admin-user

########################################################
# установка ceph cluster with Rook
########################################################
для начала нужно создать 3 worker ноды и создать на них разделы смонтированные в /data
https://itnext.io/deploy-a-ceph-cluster-on-kubernetes-with-rook-d75a20c3f5b1
git clone https://github.com/rook/rook.git
cd rook
git checkout release-1.2
cd cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
kubectl create -f operator.yaml
kubectl get pod -n rook-ceph
kubectl apply -f cluster.yaml # поправить dataDirHostPath: /data
kubectl apply -f .storageclass.yaml
kubectl get sc
kubectl apply -f dashboard.yaml # дашбоард Ceph через LB 
