kubectl describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2
