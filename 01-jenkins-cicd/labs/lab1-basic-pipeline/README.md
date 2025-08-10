# Лабораторная работа 1: Создание базового pipeline

## Цель
Создать простой Jenkins pipeline, который выполняет базовые операции сборки и тестирования.

## Задачи

### Задача 1: Установка Jenkins
1. Установите Jenkins используя Docker:
```bash
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

2. Откройте браузер и перейдите на `http://localhost:8080`

3. Получите initial admin password:
```bash
docker exec <container_id> cat /var/lib/jenkins/secrets/initialAdminPassword
```

4. Установите рекомендуемые плагины

### Задача 2: Создание первого pipeline
1. Создайте новый Pipeline job в Jenkins
2. Назовите его `my-first-pipeline`
3. В разделе Pipeline выберите "Pipeline script from SCM"
4. Выберите Git как SCM
5. Укажите URL вашего репозитория

### Задача 3: Создание Jenkinsfile
Создайте файл `Jenkinsfile` в корне вашего репозитория со следующим содержимым:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World!'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'sleep 3'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'sleep 2'
            }
        }
    }
}
```

### Задача 4: Запуск pipeline
1. Сохраните изменения в Git
2. Запустите pipeline в Jenkins
3. Проверьте, что все этапы выполнились успешно

## Критерии оценки

- [ ] Jenkins успешно установлен и настроен
- [ ] Pipeline создан и настроен
- [ ] Jenkinsfile добавлен в репозиторий
- [ ] Pipeline выполняется без ошибок
- [ ] Все этапы (Hello, Build, Test) выполняются

## Дополнительные задания

1. Добавьте этап "Deploy" в pipeline
2. Добавьте условие, чтобы deploy выполнялся только для main ветки
3. Добавьте уведомления об успешном/неуспешном выполнении

## Время выполнения: 30 минут
