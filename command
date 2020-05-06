minikube start --driver=virtualbox --cpus=2 --memory=8gb --disk-size=40gb
kubectl get componentstatuses
kubectl cluster-info
kubectl exec -it hello bash
kubectl logs hello
kubectl port-forward hello 1234:80
kubectl label node k8s-node2 node-role.kubernetes.io/worker=
kubectl label node k8s-node2 node-role.kubernetes.io/worker- #delete label
