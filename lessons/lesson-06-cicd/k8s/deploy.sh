#!/bin/bash

# ============================================
# LearnReact Kubernetes Deployment Script
# ============================================
# This script helps deploy the application to a Kubernetes cluster

set -e

# Configuration
NAMESPACE="learnreact"
APP_NAME="learnreact"
REGISTRY="${DOCKER_REGISTRY:-registry.gitlab.com}"
PROJECT_PATH="${CI_PROJECT_PATH:-your-gitlab-username/learnreact}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is not installed. Please install it first."
        exit 1
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install it first."
        exit 1
    fi
    
    log_info "All prerequisites are met."
}

build_images() {
    log_info "Building Docker images..."
    
    # Build backend
    log_info "Building backend image..."
    docker build -t "${REGISTRY}/${PROJECT_PATH}/backend:latest" -f LearnReact.Api/Dockerfile LearnReact.Api
    
    # Build frontend
    log_info "Building frontend image..."
    docker build -t "${REGISTRY}/${PROJECT_PATH}/frontend:latest" -f LearnReact.Frontend/Dockerfile LearnReact.Frontend
    
    log_info "Docker images built successfully."
}

push_images() {
    log_info "Pushing Docker images to registry..."
    
    docker push "${REGISTRY}/${PROJECT_PATH}/backend:latest"
    docker push "${REGISTRY}/${PROJECT_PATH}/frontend:latest"
    
    log_info "Docker images pushed successfully."
}

deploy() {
    log_info "Deploying to Kubernetes cluster..."
    
    # Create namespace if it doesn't exist
    kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
    
    # Apply all Kubernetes manifests
    log_info "Applying ConfigMap..."
    kubectl apply -f k8s/configmap.yml
    
    log_info "Applying Secrets..."
    kubectl apply -f k8s/secrets.yml
    
    log_info "Applying nginx ConfigMap..."
    kubectl apply -f k8s/nginx-configmap.yml
    
    log_info "Applying backend deployment..."
    kubectl apply -f k8s/backend-deployment.yml
    
    log_info "Applying frontend deployment..."
    kubectl apply -f k8s/frontend-deployment.yml
    
    log_info "Applying backend service..."
    kubectl apply -f k8s/backend-service.yml
    
    log_info "Applying frontend service..."
    kubectl apply -f k8s/frontend-service.yml
    
    log_info "Applying HorizontalPodAutoscaler..."
    kubectl apply -f k8s/backend-hpa.yml
    
    log_info "Applying Ingress..."
    kubectl apply -f k8s/ingress.yml
    
    # Wait for deployments
    log_info "Waiting for backend deployment to complete..."
    kubectl rollout status deployment/${APP_NAME}-backend -n ${NAMESPACE}
    
    log_info "Waiting for frontend deployment to complete..."
    kubectl rollout status deployment/${APP_NAME}-frontend -n ${NAMESPACE}
    
    log_info "Deployment completed successfully!"
}

show_status() {
    log_info "Showing deployment status..."
    
    echo ""
    log_info "Pods:"
    kubectl get pods -n ${NAMESPACE}
    
    echo ""
    log_info "Services:"
    kubectl get services -n ${NAMESPACE}
    
    echo ""
    log_info "Ingress:"
    kubectl get ingress -n ${NAMESPACE}
    
    echo ""
    log_info "HorizontalPodAutoscaler:"
    kubectl get hpa -n ${NAMESPACE}
}

scale() {
    local replicas=$1
    
    log_info "Scaling backend to ${replicas} replicas..."
    kubectl scale deployment/${APP_NAME}-backend -n ${NAMESPACE} --replicas=${replicas}
    
    log_info "Scaling frontend to ${replicas} replicas..."
    kubectl scale deployment/${APP_NAME}-frontend -n ${NAMESPACE} --replicas=${replicas}
}

restart() {
    log_info "Restarting deployments..."
    
    kubectl rollout restart deployment/${APP_NAME}-backend -n ${NAMESPACE}
    kubectl rollout restart deployment/${APP_NAME}-frontend -n ${NAMESPACE}
    
    log_info "Restart initiated. Use 'show-status' to check progress."
}

show_help() {
    echo "LearnReact Kubernetes Deployment Script"
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  build       Build Docker images"
    echo "  push        Push Docker images to registry"
    echo "  deploy      Deploy to Kubernetes cluster"
    echo "  status      Show deployment status"
    echo "  scale       Scale deployments (usage: scale <replicas>)"
    echo "  restart     Restart all deployments"
    echo "  all         Build, push, and deploy (full deployment)"
    echo "  help        Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  DOCKER_REGISTRY    Docker registry URL (default: registry.gitlab.com)"
    echo "  CI_PROJECT_PATH    GitLab project path (default: your-gitlab-username/learnreact)"
}

# Main script
case "${1:-help}" in
    build)
        check_prerequisites
        build_images
        ;;
    push)
        push_images
        ;;
    deploy)
        deploy
        show_status
        ;;
    status)
        show_status
        ;;
    scale)
        scale "${2:-2}"
        ;;
    restart)
        restart
        ;;
    all)
        check_prerequisites
        build_images
        push_images
        deploy
        show_status
        ;;
    help|*)
        show_help
        ;;
esac
