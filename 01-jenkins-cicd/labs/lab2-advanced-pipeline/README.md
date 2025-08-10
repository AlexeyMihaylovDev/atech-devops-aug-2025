# Лабораторная работа 2: Продвинутый pipeline

## Цель
Создать более сложный Jenkins pipeline с интеграцией Git, условной логикой и уведомлениями.

## Задачи

### Задача 1: Настройка Git интеграции
1. Убедитесь, что у вас есть Git репозиторий с кодом
2. Настройте webhook в вашем Git репозитории (GitHub/GitLab)
3. Настройте Jenkins для работы с webhook'ами

### Задача 2: Создание продвинутого Jenkinsfile
Создайте `Jenkinsfile` со следующими возможностями:

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'my-application'
        VERSION = '1.0.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'echo "Building ${APP_NAME} version ${VERSION}"'
                sh 'sleep 5'
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        echo 'Running unit tests...'
                        sh 'sleep 3'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        echo 'Running integration tests...'
                        sh 'sleep 4'
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to staging...'
                sh 'echo "Deploying to staging environment"'
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                echo 'Deploying to production...'
                sh 'echo "Deploying to production environment"'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

### Задача 3: Настройка уведомлений
1. Установите плагин Email Extension Plugin
2. Настройте SMTP сервер в Jenkins
3. Добавьте уведомления по email в pipeline

### Задача 4: Работа с артефактами
1. Добавьте этап для архивирования артефактов
2. Настройте публикацию артефактов

## Критерии оценки

- [ ] Git интеграция настроена
- [ ] Pipeline выполняется при push в репозиторий
- [ ] Параллельное выполнение тестов работает
- [ ] Условная логика (when) работает корректно
- [ ] Уведомления отправляются
- [ ] Артефакты сохраняются

## Дополнительные задания

1. Добавьте интеграцию с SonarQube для анализа кода
2. Настройте интеграцию с Docker для создания образов
3. Добавьте этап для отправки уведомлений в Slack

## Время выполнения: 45 минут
