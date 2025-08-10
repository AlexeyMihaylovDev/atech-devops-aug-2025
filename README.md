# DevOps Training Course

## Обзор курса

Этот курс предназначен для изучения основных инструментов DevOps. Курс разделен на 4 модуля, каждый из которых включает теоретическую часть и практические лабораторные работы.

### Структура курса

- **Модуль 1: Jenkins CI/CD** - Автоматизация сборки и развертывания
- **Модуль 2: Terraform AWS IaC** - Инфраструктура как код в AWS
- **Модуль 3: Ansible IaC** - Конфигурационное управление и автоматизация
- **Модуль 4: Docker** - Контейнеризация приложений

### Временные рамки

- **Теория**: 4 часа (1 час на модуль)
- **Практика**: 4 часа (1 час на модуль)
- **Общее время**: 8 часов

### Требования

- Базовые знания Linux
- Понимание концепций DevOps
- Доступ к AWS аккаунту (для модуля Terraform)
- Установленные инструменты (см. каждый модуль)

### Структура папок

```
├── 01-jenkins-cicd/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-pipeline/
│   │   │   └── Jenkinsfile
│   │   └── java-maven-pipeline/
│   │       └── Jenkinsfile
│   └── labs/
│       ├── lab1-basic-pipeline/
│       │   └── README.md
│       └── lab2-advanced-pipeline/
│           └── README.md
├── 02-terraform-aws/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-ec2/
│   │   │   └── main.tf
│   │   └── modular-vpc/
│   │       └── variables.tf
│   └── labs/
│       └── lab1-basic-infrastructure/
│           └── README.md
├── 03-ansible/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-playbook/
│   │   │   └── playbook.yml
│   │   └── role-example/
│   │       └── roles/webserver/tasks/main.yml
│   └── labs/
│       └── lab1-basic-playbook/
│           └── README.md
└── 04-docker/
    ├── README.md
    ├── examples/
    │   ├── simple-webapp/
    │   │   ├── Dockerfile
    │   │   └── index.html
    │   └── multi-stage/
    │       └── Dockerfile
    └── labs/
        └── lab1-basic-docker/
            └── README.md
```

### Как использовать

1. **Начните с изучения теоретического материала** в `README.md` каждого модуля
2. **Выполните практические примеры** в папке `examples/`
3. **Завершите лабораторные работы** в папке `labs/`

### Программа обучения

#### День 1: Jenkins CI/CD (2 часа)
- **Теория (1 час)**: Концепции CI/CD, Jenkins архитектура, Pipeline'ы
- **Практика (1 час)**: Установка Jenkins, создание pipeline'ов, интеграция с Git

#### День 2: Terraform AWS IaC (2 часа)
- **Теория (1 час)**: Infrastructure as Code, Terraform основы, AWS провайдер
- **Практика (1 час)**: Создание VPC, EC2 инстансов, модули

#### День 3: Ansible IaC (2 часа)
- **Теория (1 час)**: Конфигурационное управление, Ansible архитектура, Playbook'и
- **Практика (1 час)**: Создание playbook'ов, роли, inventory

#### День 4: Docker (2 часа)
- **Теория (1 час)**: Контейнеризация, Docker архитектура, Dockerfile
- **Практика (1 час)**: Создание образов, контейнеры, Docker Compose

### Оценка

Каждый модуль включает:
- **Теоретический тест** - проверка понимания концепций
- **Практическое задание** - выполнение лабораторных работ
- **Домашнее задание** - самостоятельная работа

### Дополнительные ресурсы

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Documentation](https://docs.docker.com/)

### Поддержка

Для вопросов и поддержки:
- Создайте issue в репозитории
- Обратитесь к документации каждого инструмента
- Используйте официальные форумы сообщества

---

**Удачи в изучении DevOps! 🚀**
