namespace LearnReact.Api.Models;

// Модель данных для задачи (Todo)
// Эта структура определяет, как выглядят данные в базе данных (или в памяти)
public class Todo
{
    // Уникальный идентификатор задачи
    public int Id { get; set; }
    
    // Название/описание задачи
    public string? Title { get; set; }
    
    // Статус выполнения: true - задача выполнена, false - ещё нет
    public bool IsCompleted { get; set; }
}
