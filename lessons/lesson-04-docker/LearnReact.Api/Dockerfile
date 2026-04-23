# Dockerfile для .NET WebAPI бэкенда
# Многоэтапная сборка для минимального размера образа

# ============================================
# ЭТАП 1: ВОССТАНОВЛЕНИЕ ЗАВИСИМОСТЕЙ
# ============================================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

# Рабочая директория
WORKDIR /src

# Копируем csproj файл для восстановления зависимостей
COPY ["LearnReact.Api.csproj", "./"]

# Восстанавливаем NuGet пакеты
RUN dotnet restore "LearnReact.Api.csproj"

# ============================================
# ЭТАП 2: СБОРКА
# ============================================
# Копируем весь исходный код
COPY . .

# Компилируем проект в режиме Release
RUN dotnet build "LearnReact.Api.csproj" -c Release -o /app/build

# ============================================
# ЭТАП 3: ПУБЛИКАЦИЯ
# ============================================
FROM build AS publish

# Публикуем (подготавливаем к запуску)
RUN dotnet publish "LearnReact.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ============================================
# ЭТАП 4: ЗАПУСК (Runtime)
# ============================================
# Минимальный образ только для запуска .NET приложений
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

# Копируем опубликованные файлы из этапа публикации
COPY --from=publish /app/publish .

# Настраиваем URL, по которому будет слушать Kestrel (.NET веб-сервер)
# http://+:5000 означает "слушать на порту 5000 на всех интерфейсах"
ENV ASPNETCORE_URLS=http://+:5000
# ASPNETCORE_ENVIRONMENT=Production включает продакшен-настройки
ENV ASPNETCORE_ENVIRONMENT=Production
# Открываем порт 5000
EXPOSE 5000

# Запускаем приложение
ENTRYPOINT ["dotnet", "LearnReact.Api.dll"]
