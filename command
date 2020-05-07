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
