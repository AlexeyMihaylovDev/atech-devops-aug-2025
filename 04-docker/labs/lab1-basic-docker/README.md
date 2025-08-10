# Лабораторная работа 1: Базовый Docker

## Цель
Создать простой Docker контейнер с веб-приложением.

## Задачи

### Задача 1: Подготовка окружения
1. Установите Docker:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# CentOS/RHEL
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# macOS
brew install --cask docker
```

2. Проверьте установку:
```bash
docker --version
docker run hello-world
```

### Задача 2: Создание простого веб-приложения
1. Создайте директорию для проекта:
```bash
mkdir docker-webapp
cd docker-webapp
```

2. Создайте файл `index.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Web App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to Docker!</h1>
        <p>This is a simple web application running in a Docker container.</p>
        <p>Current time: <span id="time"></span></p>
    </div>
    <script>
        document.getElementById('time').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
```

### Задача 3: Создание Dockerfile
Создайте файл `Dockerfile`:

```dockerfile
# Use the official nginx image as base
FROM nginx:alpine

# Copy the HTML file to nginx's default directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Задача 4: Сборка и запуск контейнера
1. Соберите образ:
```bash
docker build -t my-webapp .
```

2. Проверьте, что образ создан:
```bash
docker images
```

3. Запустите контейнер:
```bash
docker run -d -p 8080:80 --name webapp my-webapp
```

4. Проверьте, что контейнер запущен:
```bash
docker ps
```

5. Откройте браузер и перейдите на `http://localhost:8080`

### Задача 5: Работа с контейнером
1. Просмотрите логи контейнера:
```bash
docker logs webapp
```

2. Войдите в контейнер:
```bash
docker exec -it webapp sh
```

3. Остановите контейнер:
```bash
docker stop webapp
```

4. Удалите контейнер:
```bash
docker rm webapp
```

5. Удалите образ:
```bash
docker rmi my-webapp
```

## Критерии оценки

- [ ] Docker установлен и настроен
- [ ] Веб-приложение создано
- [ ] Dockerfile создан
- [ ] Образ успешно собран
- [ ] Контейнер запущен и доступен
- [ ] Веб-страница отображается корректно
- [ ] Контейнер остановлен и удален

## Дополнительные задания

1. Добавьте кастомную nginx конфигурацию
2. Создайте volume для хранения данных
3. Настройте переменные окружения
4. Создайте .dockerignore файл

## Время выполнения: 30 минут
