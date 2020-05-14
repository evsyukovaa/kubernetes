minikube start --driver=virtualbox --cpus=2 --memory=8gb --disk-size=40gb
kubectl get componentstatuses
kubectl cluster-info
kubectl exec -it hello bash
kubectl logs hello
kubectl port-forward hello 1234:80
kubectl label node k8s-node2 node-role.kubernetes.io/worker= #add label node
kubectl label node k8s-node2 node-role.kubernetes.io/worker- #delete label
kubectl get po -L creation_method,env # посмотреть labels
kubectl label po wordpress-manual creation_method=manual # добавить метки
kubectl label po wordpress-v2 env=debug --overwrite #изменить метку
kubectl create -f wordpress-manual-with-labels.yaml -n dev-namespace # создание пода в пространстве имен
kubectl get po -n dev-namespace --show-labels
kubectl delete po -l creation_method=manual #удалить поды с лэйблом manual
kubectl delete ns stage-namespace # удалить все поды в пространстве имен
etcdctl endpoint status --cert="/etc/kubernetes/pki/etcd/peer.crt" --key="/etc/kubernetes/pki/etcd/peer.key" --cacert="/etc/kubernetes/pki/etcd/ca.crt" --endpoints=https://192.168.32.67:2379 -w table
etcdctl --cert="/etc/kubernetes/pki/etcd/peer.crt" --key="/etc/kubernetes/pki/etcd/peer.key" --cacert="/etc/kubernetes/pki/etcd/ca.crt" --endpoints=https://192.168.32.67:2379 member list
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
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo
