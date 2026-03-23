import { useState, useEffect } from 'react'

// Главный компонент приложения
// Здесь мы получаем данные от бэкенда и отображаем их
function App() {
  // Состояние для хранения списка задач (todos)
  const [todos, setTodos] = useState([])
  // Состояние для хранения новой задачи
  const [newTodo, setNewTodo] = useState('')
  // Состояние для отслеживания загрузки
  const [loading, setLoading] = useState(true)

  // Загружаем данные при первом рендере компонента
  useEffect(() => {
    fetchTodos()
  }, [])

  // Функция для получения списка задач с бэкенда
  // Отправляем GET-запрос на /api/todo
  const fetchTodos = async () => {
    try {
      const response = await fetch('/api/todo')
      // Получаем JSON из ответа
      const data = await response.json()
      // Обновляем состояние с данными
      setTodos(data)
    } catch (error) {
      console.error('Ошибка при загрузке задач:', error)
    } finally {
      setLoading(false)
    }
  }

  // Функция для добавления новой задачи
  // Отправляем POST-запрос на /api/todo
  const addTodo = async (e) => {
    e.preventDefault()
    
    if (!newTodo.trim()) return

    try {
      const response = await fetch('/api/todo', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        // Отправляем данные в формате JSON
        body: JSON.stringify({ 
          title: newTodo,
          isCompleted: false 
        })
      })
      
      if (response.ok) {
        // Получаем созданную задачу
        const createdTodo = await response.json()
        // Добавляем её в список
        setTodos([...todos, createdTodo])
        // Очищаем поле ввода
        setNewTodo('')
      }
    } catch (error) {
      console.error('Ошибка при создании задачи:', error)
    }
  }

  // Функция для переключения статуса задачи
  // Отправляем PUT-запрос на /api/todo/{id}
  const toggleTodo = async (todo) => {
    try {
      const response = await fetch(`/api/todo/${todo.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        // Отправляем обновлённые данные
        body: JSON.stringify({ 
          id: todo.id,
          title: todo.title,
          isCompleted: !todo.isCompleted 
        })
      })
      
      if (response.ok) {
        // Обновляем задачу в списке
        setTodos(todos.map(t => 
          t.id === todo.id ? { ...t, isCompleted: !t.isCompleted } : t
        ))
      }
    } catch (error) {
      console.error('Ошибка при обновлении задачи:', error)
    }
  }

  // Функция для удаления задачи
  // Отправляем DELETE-запрос на /api/todo/{id}
  const deleteTodo = async (id) => {
    try {
      const response = await fetch(`/api/todo/${id}`, {
        method: 'DELETE'
      })
      
      if (response.ok) {
        // Удаляем задачу из списка
        setTodos(todos.filter(t => t.id !== id))
      }
    } catch (error) {
      console.error('Ошибка при удалении задачи:', error)
    }
  }

  return (
    <div className="app">
      <h1>React + .NET WebAPI Demo</h1>
      <p className="description">
        Фронтенд на React общается с бэкендом на C# через HTTP API
      </p>

      {/* Форма добавления задачи */}
      <form onSubmit={addTodo} className="todo-form">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Добавить новую задачу..."
          className="todo-input"
        />
        <button type="submit" className="add-button">
          Добавить
        </button>
      </form>

      {/* Список задач */}
      <div className="todo-list">
        {loading ? (
          <p>Загрузка...</p>
        ) : (
          todos.map(todo => (
            <div key={todo.id} className="todo-item">
              <input
                type="checkbox"
                checked={todo.isCompleted}
                onChange={() => toggleTodo(todo)}
              />
              <span className={todo.isCompleted ? 'completed' : ''}>
                {todo.title}
              </span>
              <button 
                onClick={() => deleteTodo(todo.id)}
                className="delete-button"
              >
                Удалить
              </button>
            </div>
          ))
        )}
      </div>
    </div>
  )
}

export default App
