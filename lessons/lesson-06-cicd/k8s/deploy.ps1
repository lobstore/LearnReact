# ============================================
# LearnReact Kubernetes Deployment Script (PowerShell)
# ============================================
# This script helps deploy the application to a Kubernetes cluster

$ErrorActionPreference = "Stop"

# Configuration
$NAMESPACE = "learnreact"
$APP_NAME = "learnreact"
$REGISTRY = if ($env:DOCKER_REGISTRY) { $env:DOCKER_REGISTRY } else { "registry.gitlab.com" }
$PROJECT_PATH = if ($env:CI_PROJECT_PATH) { $env:CI_PROJECT_PATH } else { "your-gitlab-username/learnreact" }

# Colors for output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Check-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    # Check kubectl
    if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
        Write-Error-Custom "kubectl is not installed. Please install it first."
        exit 1
    }
    
    # Check Docker
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Error-Custom "Docker is not installed. Please install it first."
        exit 1
    }
    
    Write-Info "All prerequisites are met."
}

function Build-Images {
    Write-Info "Building Docker images..."
    
    # Build backend
    Write-Info "Building backend image..."
    docker build -t "${REGISTRY}/${PROJECT_PATH}/backend:latest" -f LearnReact.Api/Dockerfile LearnReact.Api
    
    # Build frontend
    Write-Info "Building frontend image..."
    docker build -t "${REGISTRY}/${PROJECT_PATH}/frontend:latest" -f LearnReact.Frontend/Dockerfile LearnReact.Frontend
    
    Write-Info "Docker images built successfully."
}

function Push-Images {
    Write-Info "Pushing Docker images to registry..."
    
    docker push "${REGISTRY}/${PROJECT_PATH}/backend:latest"
    docker push "${REGISTRY}/${PROJECT_PATH}/frontend:latest"
    
    Write-Info "Docker images pushed successfully."
}

function Deploy {
    Write-Info "Deploying to Kubernetes cluster..."
    
    # Create namespace if it doesn't exist
    kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply all Kubernetes manifests
    Write-Info "Applying ConfigMap..."
    kubectl apply -f k8s/configmap.yml
    
    Write-Info "Applying Secrets..."
    kubectl apply -f k8s/secrets.yml
    
    Write-Info "Applying nginx ConfigMap..."
    kubectl apply -f k8s/nginx-configmap.yml
    
    Write-Info "Applying backend deployment..."
    kubectl apply -f k8s/backend-deployment.yml
    
    Write-Info "Applying frontend deployment..."
    kubectl apply -f k8s/frontend-deployment.yml
    
    Write-Info "Applying backend service..."
    kubectl apply -f k8s/backend-service.yml
    
    Write-Info "Applying frontend service..."
    kubectl apply -f k8s/frontend-service.yml
    
    Write-Info "Applying HorizontalPodAutoscaler..."
    kubectl apply -f k8s/backend-hpa.yml
    
    Write-Info "Applying Ingress..."
    kubectl apply -f k8s/ingress.yml
    
    # Wait for deployments
    Write-Info "Waiting for backend deployment to complete..."
    kubectl rollout status deployment/${APP_NAME}-backend -n ${NAMESPACE}
    
    Write-Info "Waiting for frontend deployment to complete..."
    kubectl rollout status deployment/${APP_NAME}-frontend -n ${NAMESPACE}
    
    Write-Info "Deployment completed successfully!"
}

function Show-Status {
    Write-Info "Showing deployment status..."
    
    Write-Host ""
    Write-Info "Pods:"
    kubectl get pods -n ${NAMESPACE}
    
    Write-Host ""
    Write-Info "Services:"
    kubectl get services -n ${NAMESPACE}
    
    Write-Host ""
    Write-Info "Ingress:"
    kubectl get ingress -n ${NAMESPACE}
    
    Write-Host ""
    Write-Info "HorizontalPodAutoscaler:"
    kubectl get hpa -n ${NAMESPACE}
}

function Scale {
    param([int]$Replicas = 2)
    
    Write-Info "Scaling backend to ${Replicas} replicas..."
    kubectl scale deployment/${APP_NAME}-backend -n ${NAMESPACE} --replicas=${Replicas}
    
    Write-Info "Scaling frontend to ${Replicas} replicas..."
    kubectl scale deployment/${APP_NAME}-frontend -n ${NAMESPACE} --replicas=${Replicas}
}

function Restart {
    Write-Info "Restarting deployments..."
    
    kubectl rollout restart deployment/${APP_NAME}-backend -n ${NAMESPACE}
    kubectl rollout restart deployment/${APP_NAME}-frontend -n ${NAMESPACE}
    
    Write-Info "Restart initiated. Use 'status' to check progress."
}

function Show-Help {
    Write-Host "LearnReact Kubernetes Deployment Script (PowerShell)"
    Write-Host ""
    Write-Host "Usage: .\deploy.ps1 <command>"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  build       Build Docker images"
    Write-Host "  push        Push Docker images to registry"
    Write-Host "  deploy      Deploy to Kubernetes cluster"
    Write-Host "  status      Show deployment status"
    Write-Host "  scale       Scale deployments (usage: scale <replicas>)"
    Write-Host "  restart     Restart all deployments"
    Write-Host "  all         Build, push, and deploy (full deployment)"
    Write-Host "  help        Show this help message"
    Write-Host ""
    Write-Host "Environment Variables:"
    Write-Host "  DOCKER_REGISTRY    Docker registry URL (default: registry.gitlab.com)"
    Write-Host "  CI_PROJECT_PATH    GitLab project path (default: your-gitlab-username/learnreact)"
}

# Main script
$command = if ($args.Count -gt 0) { $args[0] } else { "help" }

switch ($command) {
    "build" {
        Check-Prerequisites
        Build-Images
    }
    "push" {
        Push-Images
    }
    "deploy" {
        Deploy
        Show-Status
    }
    "status" {
        Show-Status
    }
    "scale" {
        $replicas = if ($args.Count -gt 1) { [int]$args[1] } else { 2 }
        Scale -Replicas $replicas
    }
    "restart" {
        Restart
    }
    "all" {
        Check-Prerequisites
        Build-Images
        Push-Images
        Deploy
        Show-Status
    }
    "help" {
        Show-Help
    }
    default {
        Show-Help
    }
}
