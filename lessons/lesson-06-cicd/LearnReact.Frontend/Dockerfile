# Dockerfile для React фронтенда
# Многоэтапная сборка: сначала собираем, потом копируем в nginx

# ============================================
# ЭТАП 1: СБОРКА
# ============================================
FROM node:alpine AS builder

# Рабочая директория в контейнере
WORKDIR /app

# Копируем package.json для установки зависимостей
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci

# Копируем исходный код
COPY . .

# Собираем продакшен-версию (минификация, оптимизация)
RUN npm run build

# ============================================
# ЭТАП 2: ПРОДАКШЕН (nginx)
# ============================================
FROM nginx:stable-alpine

# Копируем собранную статику из этапа сборки
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

# Запускаем nginx в foreground режиме
CMD ["nginx", "-g", "daemon off;"]
