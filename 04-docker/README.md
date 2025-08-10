# Модуль 4: Docker

## Цели обучения

- Понимание концепций контейнеризации
- Установка и настройка Docker
- Создание Docker образов
- Работа с Docker контейнерами
- Docker Compose и оркестрация

## Теоретическая часть (1 час)

### 4.1 Что такое Docker?

Docker - это платформа для разработки, доставки и запуска приложений в контейнерах:
- **Контейнер** - изолированная среда для приложения
- **Образ** - шаблон для создания контейнеров
- **Registry** - хранилище образов (Docker Hub, AWS ECR, etc.)

### 4.2 Основные концепции

#### Container
Контейнер - это изолированный процесс, который:
- Имеет собственные файловую систему, CPU, память
- Изолирован от других контейнеров
- Легко переносится между средами

#### Image
Образ - это неизменяемый шаблон:
- Содержит код, runtime, библиотеки
- Создается из Dockerfile
- Может быть версионирован

#### Dockerfile
Файл с инструкциями для создания образа:

```dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y nginx
COPY index.html /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 4.3 Архитектура Docker

```
┌─────────────────┐
│   Docker CLI    │
├─────────────────┤
│  Docker Daemon  │
├─────────────────┤
│   Containers    │
│   ┌─────────┐   │
│   │ App 1   │   │
│   └─────────┘   │
│   ┌─────────┐   │
│   │ App 2   │   │
│   └─────────┘   │
└─────────────────┘
```

### 4.4 Основные команды

#### Работа с образами
```bash
# Сборка образа
docker build -t myapp:latest .

# Просмотр образов
docker images

# Удаление образа
docker rmi myapp:latest
```

#### Работа с контейнерами
```bash
# Запуск контейнера
docker run -d -p 8080:80 myapp:latest

# Просмотр контейнеров
docker ps

# Остановка контейнера
docker stop <container_id>

# Удаление контейнера
docker rm <container_id>
```

### 4.5 Dockerfile инструкции

#### FROM
Базовый образ:
```dockerfile
FROM ubuntu:20.04
FROM node:16-alpine
FROM python:3.9-slim
```

#### RUN
Выполнение команд:
```dockerfile
RUN apt-get update && apt-get install -y nginx
RUN npm install
```

#### COPY/ADD
Копирование файлов:
```dockerfile
COPY app.js /app/
COPY package*.json ./
```

#### WORKDIR
Рабочая директория:
```dockerfile
WORKDIR /app
```

#### EXPOSE
Открытие портов:
```dockerfile
EXPOSE 80
EXPOSE 3000
```

#### CMD/ENTRYPOINT
Команда по умолчанию:
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["node", "app.js"]
```

### 4.6 Docker Compose

Инструмент для определения и запуска многоконтейнерных приложений:

```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    depends_on:
      - db
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

### 4.7 Volumes и Networks

#### Volumes
Постоянное хранение данных:
```bash
# Создание volume
docker volume create mydata

# Использование volume
docker run -v mydata:/app/data myapp
```

#### Networks
Сетевое взаимодействие между контейнерами:
```bash
# Создание сети
docker network create mynetwork

# Подключение к сети
docker run --network mynetwork myapp
```

### 4.8 Лучшие практики

1. **Многоэтапная сборка**:
```dockerfile
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

2. **Минимизация размера**:
- Используйте alpine образы
- Удаляйте ненужные файлы
- Объединяйте RUN команды

3. **Безопасность**:
- Не запускайте контейнеры от root
- Используйте .dockerignore
- Регулярно обновляйте базовые образы

## Практическая часть

### Установка Docker

1. **Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

2. **CentOS/RHEL**:
```bash
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

3. **macOS**:
```bash
brew install --cask docker
```

### Проверка установки
```bash
docker --version
docker run hello-world
```

## Домашнее задание

1. Установите Docker
2. Создайте простой Dockerfile для веб-приложения
3. Соберите и запустите контейнер
4. Настройте Docker Compose для многоконтейнерного приложения
5. Создайте volume для хранения данных

## Полезные ссылки

- [Официальная документация Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
