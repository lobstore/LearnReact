// Program.cs - Точка входа ASP.NET Core WebAPI приложения
// Этот файл настраивает сервер и определяет API-эндпоинты

var builder = WebApplication.CreateBuilder(args);

// Добавляем службы в контейнер зависимостей
// AddCors - разрешает Cross-Origin Resource Sharing (CORS)
// Это необходимо, чтобы фронтенд (React на порту 5173) мог обращаться к бэкенду (порт 5000)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp", policy =>
    {
        policy.WithOrigins("http://localhost") // Разрешаем запросы с адреса React-приложения
              .AllowAnyMethod()                      // Разрешаем любые HTTP-методы (GET, POST, PUT, DELETE)
              .AllowAnyHeader();                     // Разрешаем любые заголовки
    });
});

// Добавляем поддержку контроллеров API
builder.Services.AddControllers();

// Добавляем health checks для Kubernetes liveness/readiness probes
builder.Services.AddHealthChecks();

var app = builder.Build();

// Настраиваем конвейер обработки HTTP-запросов
if (app.Environment.IsDevelopment())
{
    // В режиме разработки включаем подробные сообщения об ошибках
    app.UseDeveloperExceptionPage();
}

// Включаем CORS (должно быть перед UseAuthorization)
app.UseCors("AllowReactApp");

// Перенаправление с HTTP на HTTPS (для безопасности)
app.UseHttpsRedirection();

// Добавляем маршрутизацию для контроллеров
app.MapControllers();

// Добавляем health check endpoint для Kubernetes
app.MapHealthChecks("/health");

// Запуск сервера
// URL берётся из переменной окружения ASPNETCORE_URLS (установлена в Dockerfile)
// http://+:5000 означает "слушать на порту 5000 на всех интерфейсах"
app.Run();
