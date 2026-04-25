# LearnReact - Учебный проект React + .NET WebAPI

Учебный проект, демонстрирующий поэтапное создание полноценного веб-приложения с фронтендом на React и бэкендом на ASP.NET Core WebAPI. Проект разделён на уроки, каждый из которых добавляет новые технологии и концепции.

## 📁 Структура проекта

```
LearnReact/
├── README.md                          # Этот файл
├── lessons/                           # Папка с уроками
│   ├── lesson-01-frontend-server/     # Урок 1: Фронтенд на React + Vite
│   │   └── LearnReact.Frontend/
│   │       ├── src/App.jsx
│   │       ├── src/main.jsx
│   │       ├── index.html
│   │       ├── package.json
│   │       └── vite.config.js
│   ├── lesson-02-backend-server/      # Урок 2: Бэкенд на ASP.NET Core WebAPI
│   │   └── LearnReact.Api/
│   │       ├── Controllers/TodoController.cs
│   │       ├── Models/Todo.cs
│   │       ├── Program.cs
│   │       └── LearnReact.Api.csproj
│   ├── lesson-03-nginx-integration/   # Урок 3: Интеграция с nginx
│   │   ├── LearnReact.Frontend/       # Фронтенд
│   │   ├── LearnReact.Api/            # Бэкенд
│   │   └── nginx/                     # Конфигурация nginx
│   ├── lesson-04-docker/              # Урок 4: Контейнеризация с Docker
│   │   ├── LearnReact.Frontend/       # Dockerfile для фронтенда
│   │   ├── LearnReact.Api/            # Dockerfile для бэкенда
│   │   ├── proxy/                     # nginx proxy
│   │   └── docker-compose.yml         # Оркестрация
│   ├── lesson-05-kubernetes/          # Урок 5: Развёртывание в Kubernetes
│   │   ├── LearnReact.Frontend/       # Фронтенд
│   │   ├── LearnReact.Api/            # Бэкенд
│   │   ├── proxy/                     # nginx proxy
│   │   ├── k8s/                       # Kubernetes манифесты
│   │   └── docker-compose.yml
│   └── lesson-06-cicd/                # Урок 6: CI/CD с GitLab
│       ├── LearnReact.Frontend/       # Фронтенд
│       ├── LearnReact.Api/            # Бэкенд
│       ├── proxy/                     # nginx proxy
│       ├── k8s/                       # Kubernetes манифесты
│       ├── docker-compose.yml
│       └── .gitlab-ci.yml             # GitLab CI/CD пайплайн
```

## 📚 Уроки

### Урок 1: Фронтенд-сервер на React + Vite

- Создание React-приложения с Vite
- Базовая структура компонентов
- Локальный запуск фронтенда на порту 5173

### Урок 2: Бэкенд-сервер на ASP.NET Core WebAPI

- Создание WebAPI проекта на .NET
- Реализация CRUD операций для модели Todo
- Локальный запуск бэкенда на порту 5000

### Урок 3: Интеграция фронтенда и бэкенда через nginx

- Настройка nginx как reverse proxy
- Объединение фронтенда и бэкенда в единое приложение
- Статическая раздача React-файлов через nginx

### Урок 4: Контейнеризация с Docker

- Создание Dockerfile для фронтенда и бэкенда
- Настройка многоэтапной сборки
- Оркестрация с docker-compose
- Запуск всего стека одной командой

### Урок 5: Развёртывание в Kubernetes

- Создание Kubernetes манифестов (Deployment, Service, Ingress)
- Настройка Namespace, ConfigMap, Secrets
- Автомасштабирование с HorizontalPodAutoscaler
- Развёртывание в minikube или облачном кластере

### Урок 6: CI/CD с GitLab

- Настройка GitLab CI/CD пайплайна
- Автоматическая сборка и тестирование
- Пуш Docker образов в GitLab Registry
- Автоматический деплой в Kubernetes

## 🚀 Быстрый старт

### Запуск конкретного урока

Каждый урок является самодостаточным. Для запуска перейдите в папку урока и следуйте инструкциям.

**Пример для урока 1 (только фронтенд):**

```bash
cd lessons/lesson-01-frontend-server/LearnReact.Frontend
npm install
npm run dev
```

**Пример для урока 2 (только бэкенд):**

```bash
cd lessons/lesson-02-backend-server/LearnReact.Api
dotnet run
```

**Пример для урока 4 (Docker):**

```bash
cd lessons/lesson-04-docker
docker-compose up --build
```

### Полный стек (Урок 4)

Для запуска всего приложения с Docker и nginx:

```bash
cd lessons/lesson-04-docker
docker-compose up --build -d
```

Приложение будет доступно по адресу: `http://localhost:80`

## 📝 API Endpoints

Все уроки используют одинаковые API endpoints:

| Метод  | URL              | Описание              |
| ------ | ---------------- | --------------------- |
| GET    | `/api/todo`      | Получить все задачи   |
| GET    | `/api/todo/{id}` | Получить задачу по ID |
| POST   | `/api/todo`      | Создать новую задачу  |
| PUT    | `/api/todo/{id}` | Обновить задачу       |
| DELETE | `/api/todo/{id}` | Удалить задачу        |

## 🛠️ Технологии

### Фронтенд

- **React 18** - библиотека для построения пользовательских интерфейсов
- **Vite** - сборщик и dev-сервер
- **CSS** - стилизация компонентов

### Бэкенд

- **ASP.NET Core 8** - фреймворк для создания WebAPI
- **C#** - язык программирования
- **REST API** - архитектурный стиль

### Инфраструктура

- **Docker** - контейнеризация приложения
- **Docker Compose** - оркестрация контейнеров
- **nginx** - веб-сервер и reverse proxy
- **Kubernetes** - оркестрация контейнеров в кластере
- **GitLab CI/CD** - непрерывная интеграция и доставка

## 🔄 Архитектура

### Локальная разработка (Уроки 1-2)

```
┌─────────────────┐      HTTP-запросы      ┌──────────────────┐
│   React         │ ─────────────────────> │  .NET WebAPI     │
│   (порт 5173)   │                        │  (порт 5000)     │
│   Vite proxy    │ <───────────────────── │                  │
└─────────────────┘      JSON-ответы       └──────────────────┘
```

### Продакшен с nginx (Урок 3)

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

### Kubernetes (Урок 5)

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

## 🐳 Docker команды

### Для урока 4

```bash
# Перейти в папку урока
cd lessons/lesson-04-docker

# Собрать и запустить
docker-compose up --build -d

# Посмотреть логи
docker-compose logs -f

# Остановить
docker-compose down

# Удалить всё (контейнеры, сети, образы)
docker-compose down --rmi all --volumes
```

## ☸️ Kubernetes (Урок 5)

### Требования

- Kubernetes кластер (minikube, kind, EKS, GKE, AKS и т.д.)
- kubectl настроенный на подключение к кластеру
- Docker для сборки образов

### Быстрый старт с minikube

```bash
# Перейти в папку урока
cd lessons/lesson-05-kubernetes

# Запустить minikube
minikube start

# Включить ingress
minikube addons enable ingress

# Развернуть приложение
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/proxy-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
kubectl apply -f k8s/frontend-service.yaml
kubectl apply -f k8s/proxy-service.yaml
kubectl apply -f k8s/ingress.yaml

# Проверить статус
kubectl get pods -n learnreact
kubectl get services -n learnreact

# Открыть приложение
minikube service learnreact-proxy-service -n learnreact --url
```

### Скрипты деплоя

В папке `k8s/` есть скрипты для автоматизации:

- `deploy.sh` - для Linux/Mac
- `deploy.ps1` - для Windows PowerShell

## 🔧 GitLab CI/CD (Урок 6)

### Настройка

1. **Создайте GitLab репозиторий** и запушьте код
2. **Настройте Docker Registry** (GitLab Container Registry доступен по умолчанию)
3. **Настройте переменные окружения в GitLab**
4. **Настройте доступ к Kubernetes кластеру**

### Пайплайн

Пайплайн состоит из следующих стадий:

- `lint` - проверка кода (backend/frontend)
- `test` - запуск тестов и сборка
- `build` - сборка Docker образов
- `push` - пуш образов в GitLab Registry
- `deploy` - деплой в Kubernetes

### Запуск пайплайна

```bash
# Локальная отладка с gitlab-ci-local
npm install -g gitlab-ci-local
gitlab-ci-local
```

## 📊 Мониторинг и логирование (Kubernetes)

```bash
# Получить все поды
kubectl get pods -n learnreact

# Получить все сервисы
kubectl get services -n learnreact

# Получить ingress
kubectl get ingress -n learnreact

# Посмотреть логи
kubectl logs -f deployment/learnreact-backend -n learnreact
kubectl logs -f deployment/learnreact-frontend -n learnreact

# Масштабирование
kubectl scale deployment/learnreact-backend -n learnreact --replicas=5

# Откат изменений
kubectl rollout undo deployment/learnreact-backend -n learnreact
```

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

### nginx

- **Раздача статики** - отдаёт JS/CSS файлы React напрямую
- **Reverse Proxy** - проксирует `/api/*` на .NET backend
- **Кэширование** - кэширует статику в браузере клиента
- **gzip** - сжимает ответы для уменьшения трафика

## 📄 Лицензия

Этот проект предназначен для образовательных целей.

## 🤝 Вклад

Если вы хотите внести вклад в проект, пожалуйста, создайте issue или pull request.
