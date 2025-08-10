# Модуль 2: Terraform AWS IaC

## Цели обучения

- Понимание концепций Infrastructure as Code (IaC)
- Установка и настройка Terraform
- Работа с AWS провайдером
- Создание и управление инфраструктурой
- Лучшие практики Terraform

## Теоретическая часть (1 час)

### 2.1 Что такое Infrastructure as Code (IaC)?

**Infrastructure as Code** - подход к управлению инфраструктурой через код, а не через ручные операции.

Преимущества:
- Версионирование инфраструктуры
- Воспроизводимость
- Автоматизация
- Документирование

### 2.2 Terraform - обзор

Terraform - это инструмент для управления инфраструктурой от HashiCorp:
- Поддерживает множество провайдеров (AWS, Azure, GCP, etc.)
- Использует декларативный синтаксис
- Сохраняет состояние инфраструктуры
- Поддерживает модули и переиспользование кода

### 2.3 Основные концепции

#### Provider
Провайдер - это плагин, который взаимодействует с облачным провайдером:
```hcl
provider "aws" {
  region = "us-west-2"
}
```

#### Resource
Ресурс - это инфраструктурный объект:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

#### Data Source
Источник данных - для получения информации о существующих ресурсах:
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}
```

#### Variable
Переменные для параметризации:
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

#### Output
Выходные значения:
```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### 2.4 Жизненный цикл Terraform

1. **terraform init** - инициализация
2. **terraform plan** - планирование изменений
3. **terraform apply** - применение изменений
4. **terraform destroy** - удаление ресурсов

### 2.5 Состояние (State)

Terraform сохраняет состояние инфраструктуры в файле или удаленном хранилище:
- Локальный файл (по умолчанию)
- S3 bucket
- Terraform Cloud
- Consul

### 2.6 Модули

Модули - это переиспользуемые компоненты:
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  environment = "production"
}
```

### 2.7 Лучшие практики

1. **Версионирование**: Используйте Git для версионирования кода
2. **Модули**: Разбивайте код на модули
3. **Переменные**: Используйте переменные для параметризации
4. **Backend**: Используйте удаленное хранение состояния
5. **Workspaces**: Используйте workspace'ы для разных окружений

## Практическая часть

### Установка Terraform

1. **Windows**:
```bash
# Скачайте с официального сайта
# https://www.terraform.io/downloads.html
```

2. **Linux**:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

3. **macOS**:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Настройка AWS

1. Установите AWS CLI
2. Настройте credentials:
```bash
aws configure
```

3. Или используйте переменные окружения:
```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_REGION="us-west-2"
```

## Домашнее задание

1. Установите Terraform и AWS CLI
2. Создайте простую VPC с подсетями
3. Разверните EC2 инстанс в созданной VPC
4. Настройте Security Groups
5. Используйте модули для организации кода

## Полезные ссылки

- [Официальная документация Terraform](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
