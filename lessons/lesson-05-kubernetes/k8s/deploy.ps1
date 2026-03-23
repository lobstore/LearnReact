param(
    [ValidateSet("apply", "delete", "clean")]
    [string]$Action = "apply"
)

$NAMESPACE = "learnreact"
$K8S_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

switch ($Action) {
    "apply" {
        kubectl apply -f "$K8S_DIR/"
        Write-Host "`nДоступно: http://localhost:8080 (port-forward) или $(minikube ip):30080"
        Write-Host "Для port-forward: kubectl port-forward -n $NAMESPACE svc/proxy 8080:80"
    }
    "delete" {
        kubectl delete -f "$K8S_DIR/"
    }
    "clean" {
        kubectl delete namespace $NAMESPACE --ignore-not-found
    }
}
