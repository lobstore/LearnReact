#!/bin/bash
NAMESPACE="learnreact"
K8S_DIR="$(dirname "$0")"

case "${1:-apply}" in
  apply)
    kubectl apply -f "$K8S_DIR/"
    echo -e "\nДоступно: http://localhost:8080 (port-forward) или $(minikube ip):30080"
    echo "Для port-forward: kubectl port-forward -n $NAMESPACE svc/proxy 8080:80"
    ;;
  delete)
    kubectl delete -f "$K8S_DIR/"
    ;;
  clean)
    kubectl delete namespace $NAMESPACE --ignore-not-found
    ;;
esac
