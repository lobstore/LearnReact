# Lesson 05: Запуск под Kubernetes

В этом уроке мы развернем наше React + .NET приложение в кластере Kubernetes с трехзвенной архитектурой.

## 🏗️ Архитектура

```
                    ┌─────────────────────────────────────────┐
                    │         Kubernetes Cluster              │
                    │                                         │
┌──────────┐       │   ┌─────────────────────────────────┐   │
│  User    │       │   │    Service/proxy:80 → NodePort  │   │
│ Browser  │ ─────►│   │         30080                   │   │
└──────────┘       │   └─────────────┬───────────────────┘   │
                   │                 │                       │
                   │                 ▼                       │
                   │   ┌─────────────────────────────────┐   │
                   │   │    Deployment/proxy             │   │
                   │   │    nginx:stable-alpine          │   │
                   │   │    - / → frontend:3000          │   │
                   │   │    - /api/* → backend:5000      │   │
                   │   └─────────────────────────────────┘   │
                   │           │                    │        │
                   │           │                    │        │
                   │           ▼                    ▼        │
                   │   ┌──────────────┐    ┌──────────────┐  │
                   │   │ Service/     │    │ Service/     │  │
                   │   │ frontend:3000│    │ backend:5000 │  │
                   │   └──────┬───────┘    └──────┬───────┘  │
                   │          │                   │          │
                   │          ▼                   ▼          │
                   │   ┌──────────────┐    ┌──────────────┐  │
                   │   │ Deployment/  │    │ Deployment/  │  │
                   │   │ frontend (2x)│    │ backend (2x) │  │
                   │   │ nginx:3000   │    │ .NET:5000    │  │
                   │   │ React static │    │ WebAPI       │  │
                   │   └──────────────┘    └──────────────┘  │
                   │                                         │
                   └─────────────────────────────────────────┘
```

## 📁 Структура манифестов

```
k8s/
├── namespace.yaml           # Namespace для изоляции
├── backend-deployment.yaml # Deployment для .NET API
├── backend-service.yaml    # Service для бэкенда
├── frontend-deployment.yaml # Deployment для React + nginx
├── frontend-service.yaml   # Service для фронтенда
├── proxy-deployment.yaml   # Deployment для proxy nginx
├── proxy-service.yaml      # NodePort Service для внешнего доступа
└── ingress.yaml            # Ingress (опционально)
```

## 🚀 Быстрый старт

### 1. Сборка Docker образов

```bash
# Сборка образа бэкенда
cd LearnReact.Api
docker build -t learnreact-backend:latest .

# Сборка образа фронтенда
cd ../LearnReact.Frontend
docker build -t learnreact-frontend:latest .

# Сборка образа proxy
cd ../proxy
docker build -t learnreact-proxy:latest .
```

### 2. Загрузка образов в кластер (Minikube)

```bash
minikube image load learnreact-backend:latest
minikube image load learnreact-frontend:latest
```

### 3. Развертывание в Kubernetes

**Windows PowerShell:**
```powershell
.\k8s\deploy.ps1 -Action apply
```

**Linux/Mac:**
```bash
./k8s/deploy.sh
```

## 🌐 Доступ к приложению

### Через NodePort (рекомендуется)

Откройте в браузере:

**http://192.168.49.2:30080**

IP адрес можно узнать командой:
```bash
minikube ip
```

### Через minikube service

```bash
minikube service proxy -n learnreact
```

Эта команда автоматически откроет браузер с туннелем к сервису.

## 🔍 Проверка статуса

```bash
# Проверка всех ресурсов
kubectl get all -n learnreact

# Проверка подов
kubectl get pods -n learnreact

# Проверка сервисов
kubectl get svc -n learnreact
```

## 📊 Компоненты

### 1. Backend (.NET WebAPI)
- **Порт:** 5000
- **Реплики:** 2
- **Endpoint:** `/api/todo`

### 2. Frontend (React + nginx)
- **Порт:** 3000
- **Реплики:** 2
- **Назначение:** Раздача статики React

### 3. Proxy (nginx)
- **Порт:** 80 → NodePort 30080
- **Реплики:** 1
- **Маршрутизация:**
  - `/` → `frontend:3000`
  - `/api/*` → `backend:5000`
- **Образ:** `learnreact-proxy:latest` (кастомный nginx.conf)

## 🧹 Удаление приложения

**Windows PowerShell:**
```powershell
.\k8s\deploy.ps1 -Action clean
```

**Linux/Mac:**
```bash
./k8s/deploy.sh clean
```

Или вручную:
```bash
kubectl delete namespace learnreact
```

## 🔧 Отладка

```bash
# Логи всех компонентов
kubectl logs -n learnreact -l app=backend -f
kubectl logs -n learnreact -l app=frontend -f
kubectl logs -n learnreact -l app=proxy -f

# Тестирование изнутри кластера
kubectl exec -n learnreact deployment/proxy -- curl -s http://frontend:3000/
kubectl exec -n learnreact deployment/proxy -- curl -s http://localhost:80/api/todo
```

## 📋 Требования

- Minikube или другой Kubernetes кластер
- kubectl CLI
- Docker для сборки образов
