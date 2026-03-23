using Microsoft.AspNetCore.Mvc;
using LearnReact.Api.Models;

namespace LearnReact.Api.Controllers;

// Контроллер для управления задачами (Todo)
// [ApiController] - указывает, что это API-контроллер (автоматическая валидация, обработка ошибок)
// [Route("api/[controller]")] - все методы будут доступны по адресу api/todo
[ApiController]
[Route("api/[controller]")]
public class TodoController : ControllerBase
{
    // Хранилище задач в памяти (для демонстрации)
    // В реальном проекте здесь было бы подключение к базе данных
    private static List<Todo> _todos = new List<Todo>
    {
        new Todo { Id = 1, Title = "Изучить React", IsCompleted = true },
        new Todo { Id = 2, Title = "Изучить .NET WebAPI", IsCompleted = false },
        new Todo { Id = 3, Title = "Создать полноценное приложение", IsCompleted = false }
    };

    // GET: api/todo
    // Получение списка всех задач
    // Фронтенд отправляет GET-запрос → этот метод возвращает JSON со списком задач
    [HttpGet]
    public ActionResult<IEnumerable<Todo>> Get()
    {
        // Возвращаем все задачи из хранилища
        // ASP.NET автоматически сериализует объект в JSON
        return Ok(_todos);
    }

    // GET: api/todo/5
    // Получение одной задачи по ID
    [HttpGet("{id}")]
    public ActionResult<Todo> Get(int id)
    {
        // Ищем задачу с указанным ID
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        
        if (todo == null)
        {
            // Если задача не найдена, возвращаем 404
            return NotFound();
        }
        
        return Ok(todo);
    }

    // POST: api/todo
    // Создание новой задачи
    // Фронтенд отправляет POST-запрос с JSON в теле → этот метод создаёт задачу
    [HttpPost]
    public ActionResult<Todo> Create([FromBody] Todo newTodo)
    {
        // Проверяем, что название не пустое
        if (string.IsNullOrWhiteSpace(newTodo.Title))
        {
            return BadRequest("Название задачи не может быть пустым");
        }

        // Генерируем новый ID (максимальный + 1)
        // Если список пустой, начинаем с 1
        newTodo.Id = _todos.Any() ? _todos.Max(t => t.Id) + 1 : 1;
        
        // Добавляем задачу в хранилище
        _todos.Add(newTodo);
        
        // Возвращаем созданную задачу с кодом 201 (Created)
        // Фронтенд получит её в ответе и добавит в список
        return CreatedAtAction(nameof(Get), new { id = newTodo.Id }, newTodo);
    }

    // PUT: api/todo/5
    // Обновление существующей задачи
    // Фронтенд отправляет PUT-запрос с обновлёнными данными → этот метод обновляет задачу
    [HttpPut("{id}")]
    public IActionResult Update(int id, [FromBody] Todo updatedTodo)
    {
        // Ищем задачу для обновления
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        
        if (todo == null)
        {
            return NotFound();
        }

        // Обновляем поля задачи
        todo.Title = updatedTodo.Title;
        todo.IsCompleted = updatedTodo.IsCompleted;
        
        // Возвращаем 204 No Content (успешное обновление без тела ответа)
        return NoContent();
    }

    // DELETE: api/todo/5
    // Удаление задачи
    // Фронтенд отправляет DELETE-запрос → этот метод удаляет задачу
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        // Ищем задачу для удаления
        var todo = _todos.FirstOrDefault(t => t.Id == id);
        
        if (todo == null)
        {
            return NotFound();
        }

        // Удаляем задачу из хранилища
        _todos.Remove(todo);
        
        // Возвращаем 204 No Content (успешное удаление без тела ответа)
        return NoContent();
    }
}
