# Модуль 1: Jenkins CI/CD

## Цели обучения

- Понимание концепций CI/CD
- Установка и настройка Jenkins
- Создание pipeline'ов
- Интеграция с Git
- Автоматизация сборки и развертывания

## Теоретическая часть (1 час)

### 1.1 Что такое CI/CD?

**Continuous Integration (CI)** - практика автоматической сборки и тестирования кода при каждом коммите.

**Continuous Deployment (CD)** - автоматическое развертывание приложения в продакшн после успешных тестов.

### 1.2 Jenkins - обзор

Jenkins - это open-source сервер автоматизации, который поддерживает:
- Сборку проектов
- Тестирование
- Развертывание
- Мониторинг

### 1.3 Основные концепции

#### Pipeline
Последовательность этапов, которые выполняются автоматически:
1. **Build** - сборка приложения
2. **Test** - запуск тестов
3. **Deploy** - развертывание

#### Job
Задача, которая выполняется Jenkins'ом. Может быть:
- Freestyle project
- Pipeline project
- Multi-configuration project

#### Node
Сервер или агент, на котором выполняются задачи.

### 1.4 Jenkinsfile

Jenkinsfile - это файл, который описывает pipeline в коде:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### 1.5 Типы pipeline'ов

#### Declarative Pipeline
Современный синтаксис, более читаемый:

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

#### Scripted Pipeline
Классический синтаксис на Groovy:

```groovy
node {
    stage('Build') {
        sh 'mvn clean package'
    }
}
```

### 1.6 Интеграция с Git

Jenkins может:
- Отслеживать изменения в репозитории
- Запускать сборку при push
- Работать с pull requests
- Поддерживать webhook'и

### 1.7 Плагины

Популярные плагины:
- **Git** - интеграция с Git
- **Docker** - работа с контейнерами
- **Pipeline** - поддержка pipeline'ов
- **Credentials** - управление секретами

## Практическая часть

### Установка Jenkins

1. **Docker** (рекомендуется):
```bash
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

2. **Ubuntu/Debian**:
```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

### Первоначальная настройка

1. Откройте `http://localhost:8080`
2. Получите initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. Установите рекомендуемые плагины
4. Создайте admin пользователя

## Домашнее задание

1. Установите Jenkins локально
2. Создайте простой pipeline для сборки Java приложения
3. Настройте интеграцию с Git репозиторием
4. Добавьте этап тестирования

## Полезные ссылки

- [Официальная документация Jenkins](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Plugins](https://plugins.jenkins.io/)
