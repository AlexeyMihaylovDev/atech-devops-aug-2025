# EC2 Complete Module

Этот модуль Terraform создает полноценную инфраструктуру для EC2 instance, включая:

- VPC с публичной и приватной подсетями
- Internet Gateway
- Route Tables
- Security Groups
- SSH Key Pair
- EC2 Instance
- Elastic IP (опционально)

## 🚀 Особенности

- **Гибкость**: Возможность развертывания в публичной или приватной подсети
- **Безопасность**: Настраиваемые security groups и шифрование EBS
- **Масштабируемость**: Легко переиспользовать для разных проектов
- **Мониторинг**: Поддержка CloudWatch мониторинга
- **Production Ready**: Готов для production использования

## 📁 Структура модуля

```
ec2-complete/
├── main.tf              # Основные ресурсы модуля
├── variables.tf         # Переменные модуля
├── outputs.tf           # Выходные значения
├── versions.tf          # Версии Terraform и провайдеров
├── README.md            # Документация модуля
├── example/             # Базовый пример использования
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── terraform.tfvars
│   └── README.md
└── example-production/  # Production пример
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    ├── terraform.tfvars
    └── README.md
```

## 🎯 Примеры использования

### 1. Базовый пример (`example/`)

Простой пример для разработки и тестирования:
- EC2 в публичной подсети
- Базовая веб-страница
- Минимальная конфигурация

**Быстрый старт:**
```bash
cd example/
terraform init
terraform plan
terraform apply
```

### 2. Production пример (`example-production/`)

Enterprise-grade инфраструктура:
- EC2 в приватной подсети
- NAT Gateway
- Application Load Balancer
- CloudWatch логи
- S3 backup

**Быстрый старт:**
```bash
cd example-production/
# Настройте terraform.tfvars
terraform init
terraform plan
terraform apply
```

## 🔧 Использование модуля

### Базовое использование

```hcl
module "ec2_complete" {
  source = "./modules/ec2-complete"
  
  project_name = "my-webapp"
  ami_id       = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
}
```

### Расширенное использование

```hcl
module "ec2_complete" {
  source = "./modules/ec2-complete"
  
  project_name = "production-app"
  ami_id       = "ami-0c02fb55956c7d316"
  instance_type = "t3.medium"
  
  # VPC Configuration
  vpc_cidr = "172.16.0.0/16"
  public_subnet_cidr = "172.16.1.0/24"
  private_subnet_cidr = "172.16.2.0/24"
  availability_zone = "us-east-1b"
  
  # Security Configuration
  allowed_ssh_cidr = ["10.0.0.0/8", "192.168.1.0/24"]
  allowed_http_cidr = ["0.0.0.0/0"]
  ssh_public_key = file("~/.ssh/id_rsa.pub")
  
  # Storage Configuration
  root_volume_size = 50
  root_volume_type = "gp3"
  encrypt_volumes = true
  
  # Deployment Configuration
  deploy_in_private = true
  enable_monitoring = true
  
  # User Data
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF
  
  # Tags
  common_tags = {
    Environment = "prod"
    Project     = "webapp"
    Owner       = "devops-team"
  }
}
```

## 📋 Переменные

### Обязательные переменные

- `project_name` - Имя проекта для ресурсов

### Опциональные переменные

#### VPC Configuration
- `vpc_cidr` - CIDR блок для VPC (по умолчанию: "10.0.0.0/16")
- `public_subnet_cidr` - CIDR блок для публичной подсети (по умолчанию: "10.0.1.0/24")
- `private_subnet_cidr` - CIDR блок для приватной подсети (по умолчанию: "10.0.2.0/24")
- `availability_zone` - Зона доступности (по умолчанию: "us-east-1a")

#### EC2 Configuration
- `ami_id` - ID AMI для EC2 instance
- `instance_type` - Тип EC2 instance (по умолчанию: "t3.micro")
- `deploy_in_private` - Развертывание в приватной подсети (по умолчанию: false)
- `enable_monitoring` - Включение детального мониторинга (по умолчанию: false)

#### Storage Configuration
- `root_volume_size` - Размер корневого тома в GB (по умолчанию: 20)
- `root_volume_type` - Тип корневого тома (по умолчанию: "gp3")
- `encrypt_volumes` - Шифрование EBS томов (по умолчанию: true)

#### Security Configuration
- `allowed_ssh_cidr` - CIDR блоки для SSH доступа
- `allowed_http_cidr` - CIDR блоки для HTTP/HTTPS доступа
- `ssh_public_key` - SSH публичный ключ

#### User Data
- `user_data` - Скрипт инициализации для EC2 instance

#### Common Configuration
- `common_tags` - Общие теги для всех ресурсов

## 📤 Выходные значения

- `vpc_id` - ID VPC
- `public_subnet_id` - ID публичной подсети
- `private_subnet_id` - ID приватной подсети
- `security_group_id` - ID security group
- `instance_id` - ID EC2 instance
- `instance_public_ip` - Публичный IP EC2 instance
- `instance_private_ip` - Приватный IP EC2 instance
- `instance_public_dns` - Публичный DNS EC2 instance
- `instance_private_dns` - Приватный DNS EC2 instance
- `key_pair_name` - Имя SSH key pair
- `elastic_ip` - Elastic IP (если развернуто в приватной подсети)
- `public_route_table_id` - ID публичной route table
- `availability_zone` - Зона доступности

## 🚦 Быстрый старт

### 1. Клонируйте репозиторий
```bash
git clone <your-repo>
cd 02-terraform-aws/examples/modules/ec2-complete
```

### 2. Выберите пример
- **Для разработки**: `cd example/`
- **Для production**: `cd example-production/`

### 3. Настройте переменные
Отредактируйте `terraform.tfvars` под ваши нужды

### 4. Запустите Terraform
```bash
terraform init
terraform plan
terraform apply
```

## 🛡️ Безопасность

- Security groups настроены для минимально необходимого доступа
- EBS тома шифруются по умолчанию
- SSH доступ можно ограничить конкретными CIDR блоками
- Поддержка приватных подсетей для production окружений
- Валидация переменных для предотвращения ошибок

## 💰 Стоимость

### Базовый пример
- **EC2 t3.micro**: ~$8-10/месяц
- **EBS gp3 30GB**: ~$3/месяц
- **VPC и подсети**: бесплатно
- **Итого**: ~$11-13/месяц

### Production пример
- **EC2 t3.medium**: ~$25-30/месяц
- **EBS gp3 50GB**: ~$5/месяц
- **NAT Gateway**: ~$45/месяц
- **ALB**: ~$20/месяц
- **Итого**: ~$95-100/месяц

## 🔄 Обновления

### Обновление модуля
```bash
# В папке с примером
terraform get -update
terraform plan
terraform apply
```

### Обновление AMI
```bash
# Измените ami_id в terraform.tfvars
terraform plan
terraform apply
```

## 🚨 Troubleshooting

### Частые проблемы

1. **AMI не найден**
   - Убедитесь что AMI ID актуален для вашего региона
   - Используйте AWS Systems Manager Parameter Store

2. **Конфликт CIDR**
   - Измените CIDR блоки в переменных
   - Убедитесь что они не пересекаются с существующими VPC

3. **Instance не запускается**
   - Проверьте security group правила
   - Убедитесь что user data скрипт корректный

### Полезные команды

```bash
# Проверить статус instance
aws ec2 describe-instances --instance-ids [INSTANCE_ID]

# Просмотреть security group правила
aws ec2 describe-security-groups --group-ids [SG_ID]

# Проверить логи user data
aws logs describe-log-groups --log-group-name-prefix "/aws/ec2"
```

## 📚 Дополнительные ресурсы

### AWS Documentation
- [VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [EC2 User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/)
- [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

### Terraform Documentation
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Language](https://www.terraform.io/docs/language/index.html)

### Best Practices
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 Поддержка

При возникновении вопросов:
1. Проверьте логи Terraform
2. Изучите AWS CloudTrail
3. Создайте issue в репозитории проекта

## 📄 Лицензия

Этот модуль распространяется под лицензией MIT. См. файл LICENSE для подробностей.

---

**🚀 Готово к использованию!** Этот модуль предоставляет полноценную инфраструктуру для быстрого развертывания EC2 instances с соблюдением best practices.
