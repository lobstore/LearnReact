# LearnReact - React + .NET WebAPI Demo

Простой пример приложения с фронтендом на React и бэкендом на ASP.NET Core WebAPI.

## 📁 Структура проекта

```
LearnReact/
├── LearnReact.Frontend/     # Фронтенд (React + Vite)
│   ├── src/
│   │   ├── App.jsx          # Главный компонент с логикой
│   │   ├── main.jsx         # Точка входа React
│   │   └── index.css        # Стили
│   ├── index.html
│   ├── package.json
│   ├── Dockerfile           # Docker для сборки React
│   └── vite.config.js       # Настройка Vite с прокси на бэкенд
│
├── LearnReact.Api/          # Бэкенд (ASP.NET Core WebAPI)
│   ├── Controllers/
│   │   └── TodoController.cs # API-контроллер для задач
│   ├── Models/
│   │   └── Todo.cs           # Модель данных
│   ├── Program.cs            # Точка входа и настройка сервера
│   └── Dockerfile            # Docker для .NET
│
├── nginx/
│   └── nginx.conf            # Конфигурация nginx (продакшен)
│
├── k8s/                      # Kubernetes манифесты
│   ├── namespace.yml         # Namespace для приложения
│   ├── configmap.yml         # Конфигурация (env variables)
│   ├── secrets.yml           # Секреты (пароли, ключи)
│   ├── nginx-configmap.yml   # Конфигурация nginx для K8s
│   ├── backend-deployment.yml # Deployment для .NET API
│   ├── frontend-deployment.yml # Deployment для React
│   ├── backend-service.yml   # Service для backend
│   ├── frontend-service.yml  # Service для frontend
│   ├── backend-hpa.yml       # HorizontalPodAutoscaler
│   ├── ingress.yml           # Ingress (внешний доступ)
│   ├── kustomization.yml     # Kustomize конфигурация
│   ├── deploy.sh             # Bash скрипт деплоя
│   └── deploy.ps1            # PowerShell скрипт деплоя
│
├── docker-compose.yml        # Оркестрация всех сервисов
├── .gitlab-ci.yml            # GitLab CI/CD пайплайн
├── .gitlabignore             # GitLab CI/CD ignore file
└── README.md
```

## 🚀 Запуск

### Вариант 1: Локальная разработка (без Docker)

**Терминал 1 - Бэкенд:**
```bash
cd LearnReact.Api
dotnet run
```
- Сервер запускается на `http://localhost:5000`

**Терминал 2 - Фронтенд:**
```bash
cd LearnReact.Frontend
npm install
npm run dev
```
- React запускается на `http://localhost:5173`
- Vite проксирует `/api/*` → `http://localhost:5000/api/*`

### Вариант 2: Продакшен (Docker + nginx)

**Одной командой:**
```bash
docker-compose up --build
```

**Или по шагам:**
```bash
# Собрать и запустить все контейнеры
docker-compose build
docker-compose up -d
```

- Приложение доступно по `http://localhost:80`
- nginx раздаёт статику React и проксирует `/api/*` на .NET

**Остановить:**
```bash
docker-compose down
```

## 🔄 Архитектура

### Локальная разработка
```
┌─────────────────┐      HTTP-запросы      ┌──────────────────┐
│   React         │ ─────────────────────> │  .NET WebAPI     │
│   (порт 5173)   │                        │  (порт 5000)     │
│   Vite proxy    │ <───────────────────── │                  │
└─────────────────┘      JSON-ответы       └──────────────────┘
```

### Продакшен (Docker + nginx)
```
                    ┌──────────────────────────────────────┐
                    │           nginx (порт 80)            │
                    │  ┌────────────┐  ┌────────────────┐  │
┌─────────┐         │  │ Статика    │  │ Прокси /api/*  │  │
│Браузер  │ ──────> │  │ React      │  │ ─────────────> │  │
└─────────┘         │  │ (фронтенд) │  │   .NET         │  │
                    │  └────────────┘  └────────────────┘  │
                    └──────────────────────────────────────┘
                                           │
                                           ▼
                              ┌──────────────────┐
                              │  .NET WebAPI     │
                              │  (порт 5000)     │
                              │  (внутри сети)   │
                              └──────────────────┘
```

## 📝 API Endpoints

| Метод | URL | Описание |
|-------|-----|----------|
| GET | `/api/todo` | Получить все задачи |
| GET | `/api/todo/{id}` | Получить задачу по ID |
| POST | `/api/todo` | Создать новую задачу |
| PUT | `/api/todo/{id}` | Обновить задачу |
| DELETE | `/api/todo/{id}` | Удалить задачу |

## 🔑 Ключевые концепции

### Фронтенд (React)
- **useState** - хранение состояния (список задач, новая задача)
- **useEffect** - загрузка данных при монтировании компонента
- **fetch** - HTTP-запросы к бэкенду

### Бэкенд (.NET WebAPI)
- **Controller** - класс с методами для обработки HTTP-запросов
- **Route** - URL-адрес для доступа к методу
- **Model** - структура данных (Todo)
- **CORS** - разрешение запросов с другого домена/порта

### nginx (Продакшен)
- **Раздача статики** - отдаёт JS/CSS файлы React напрямую
- **Reverse Proxy** - проксирует `/api/*` на .NET backend
- **Кэширование** - кэширует статику в браузере клиента
- **gzip** - сжимает ответы для уменьшения трафика

## 🛠️ Docker команды

```bash
# Запустить всё
docker-compose up -d

# Посмотреть логи
docker-compose logs -f

# Остановить всё
docker-compose down

# Пересобрать и запустить
docker-compose up --build -d

# Удалить всё (контейнеры, сети, образы)
docker-compose down --rmi all --volumes
```

## ☸️ Kubernetes

### Требования
- Kubernetes кластер (minikube, kind, EKS, GKE, AKS и т.д.)
- kubectl настроенный на подключение к кластеру
- Docker для сборки образов

### Быстрый старт с minikube

```bash
# Запустить minikube
minikube start

# Включить ingress
minikube addons enable ingress

# Развернуть приложение (используя скрипт)
./k8s/deploy.sh all

# Или вручную применить все манифесты
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secrets.yml
kubectl apply -f k8s/nginx-configmap.yml
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/frontend-deployment.yml
kubectl apply -f k8s/backend-service.yml
kubectl apply -f k8s/frontend-service.yml
kubectl apply -f k8s/backend-hpa.yml
kubectl apply -f k8s/ingress.yml

# Проверить статус
kubectl get pods -n learnreact
kubectl get services -n learnreact

# Открыть приложение
minikube service learnreact-frontend-service -n learnreact --url
```

### Использование Kustomize

```bash
# Применить все конфигурации через kustomize
kubectl apply -k k8s/

# Создать overlay для production
mkdir -p k8s/overlays/production
```

### Скрипты деплоя

**Bash (Linux/Mac):**
```bash
# Показать помощь
./k8s/deploy.sh help

# Собрать образы
./k8s/deploy.sh build

# Отправить в registry
./k8s/deploy.sh push

# Развернуть в кластере
./k8s/deploy.sh deploy

# Полный цикл (build + push + deploy)
./k8s/deploy.sh all

# Показать статус
./k8s/deploy.sh status

# Масштабировать
./k8s/deploy.sh scale 5

# Перезапустить
./k8s/deploy.sh restart
```

**PowerShell (Windows):**
```powershell
# Разрешить выполнение скриптов
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Показать помощь
.\k8s\deploy.ps1 help

# Полный цикл
.\k8s\deploy.ps1 all
```

### Переменные окружения

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| `DOCKER_REGISTRY` | Docker registry URL | `registry.gitlab.com` |
| `CI_PROJECT_PATH` | Путь проекта в registry | `your-gitlab-username/learnreact` |

### Настройка Ingress

Отредактируйте `k8s/ingress.yml`:
```yaml
spec:
  rules:
    - host: your-domain.com  # Замените на ваш домен
```

Для HTTPS раскомментируйте TLS секцию и настройте cert-manager.

## 🔧 GitLab CI/CD

### Настройка

1. **Создайте GitLab репозиторий** и запушьте код

2. **Настройте Docker Registry:**
   - GitLab Container Registry доступен по умолчанию
   - Образы будут пушиться в `registry.gitlab.com/your-username/learnreact`

3. **Настройте переменные окружения в GitLab:**
   ```
   Settings → CI/CD → Variables
   
   DOCKER_REGISTRY      registry.gitlab.com
   DOCKER_HOST          tcp://docker:2375
   DOCKER_TLS_CERTDIR   ""
   ```

4. **Настройте доступ к Kubernetes кластеру:**
   - Создайте ServiceAccount и kubeconfig
   - Добавьте kubeconfig как GitLab CI/CD variable `KUBECONFIG`

### Пайплайн

Пайплайн состоит из следующих стадий:

| Стадия | Описание |
|--------|----------|
| `lint` | Проверка кода (backend/frontend) |
| `test` | Запуск тестов и сборка |
| `build` | Сборка Docker образов |
| `push` | Пуш образов в GitLab Registry |
| `deploy` | Деплой в Kubernetes |

### Ветки и окружения

| Ветка | Действие | Окружение |
|-------|----------|-----------|
| `develop` | Авто-деплой | Staging |
| `main` | Ручной деплой | Production |
| Tag | Ручной деплой | Production |

### Запуск пайплайна

```bash
# Локальная отладка с gitlab-ci-local
npm install -g gitlab-ci-local
gitlab-ci-local
```

### Манифесты для деплоя

После успешного билда и пуша, пайплайн автоматически:
1. Обновляет image tags в Kubernetes манифестах
2. Применяет все манифесты к кластеру
3. Ждёт завершения rollout
4. Показывает статус деплоя

## 📊 Мониторинг и логирование

### Проверка статуса

```bash
# Получить все поды
kubectl get pods -n learnreact

# Получить все сервисы
kubectl get services -n learnreact

# Получить ingress
kubectl get ingress -n learnreact

# Получить HPA
kubectl get hpa -n learnreact

# Описать под (для отладки)
kubectl describe pod <pod-name> -n learnreact

# Посмотреть логи
kubectl logs -f deployment/learnreact-backend -n learnreact
kubectl logs -f deployment/learnreact-frontend -n learnreact
```

### Масштабирование

```bash
# Автоматическое (через HPA)
# Backend автоматически масштабируется от 2 до 10 реплик

# Ручное масштабирование
kubectl scale deployment/learnreact-backend -n learnreact --replicas=5
```

### Откат изменений

```bash
# Откатить deployment
kubectl rollout undo deployment/learnreact-backend -n learnreact

# Проверить историю
kubectl rollout history deployment/learnreact-backend -n learnreact
```
