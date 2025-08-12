# Production Environment Example

Этот пример демонстрирует развертывание production-ready инфраструктуры с использованием модуля `ec2-complete`.

## 🚀 Production Features

### Безопасность
- **Приватная подсеть** для EC2 instance
- **NAT Gateway** для исходящего интернет-доступа
- **Ограниченный SSH доступ** только с разрешенных CIDR блоков
- **Шифрование EBS томов** по умолчанию
- **Security Groups** с минимально необходимыми правилами

### Масштабируемость
- **Application Load Balancer** для распределения нагрузки
- **Target Groups** с health checks
- **Auto Scaling** готовность (можно легко добавить)

### Мониторинг и логирование
- **CloudWatch мониторинг** включен
- **CloudWatch Log Groups** для application логов
- **Health checks** на уровне ALB
- **Метрики производительности**

### Резервное копирование
- **S3 bucket** для application данных
- **Versioning** включен
- **Шифрование** на стороне сервера
- **Public access** заблокирован

## 🏗️ Архитектура

```
Internet
    │
    ▼
┌─────────────────┐
│   Route Table   │
│   (Public)      │
└─────────────────┘
    │
    ▼
┌─────────────────┐    ┌─────────────────┐
│ Public Subnet   │    │ Private Subnet  │
│                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Internet     │ │    │ │EC2 Instance │ │
│ │Gateway      │ │    │ │             │ │
│ └─────────────┘ │    │ └─────────────┘ │
│                 │    │                 │
│ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │NAT Gateway  │ │    │ │Route Table  │ │
│ │             │ │    │ │(Private)    │ │
│ └─────────────┘ │    │ └─────────────┘ │
│                 │    │                 │
│ ┌─────────────┐ │    └─────────────────┘
│ │ALB          │ │
│ │             │ │
│ └─────────────┘ │
└─────────────────┘
```

## 📋 Что создается

### Основная инфраструктура (из модуля)
- **VPC** с CIDR `10.0.0.0/16`
- **Публичная подсеть** `10.0.1.0/24`
- **Приватная подсеть** `10.0.2.0/24`
- **Internet Gateway**
- **EC2 Instance** в приватной подсети
- **Security Groups**
- **SSH Key Pair**

### Дополнительные production ресурсы
- **NAT Gateway** с Elastic IP
- **Route Table** для приватной подсети
- **Application Load Balancer** (опционально)
- **Target Group** с health checks
- **CloudWatch Log Group**
- **S3 Bucket** для backup (опционально)

## 🚦 Быстрый старт

### Предварительные требования

1. **AWS CLI** настроен с правами администратора
2. **Terraform** версии 1.0 или выше
3. **SSH ключ** для доступа к instance
4. **Понимание** production требований

### Шаги для запуска

1. **Перейдите в папку production примера:**
   ```bash
   cd 02-terraform-aws/examples/modules/ec2-complete/example-production
   ```

2. **Настройте переменные:**
   ```bash
   # Отредактируйте terraform.tfvars
   # Особое внимание уделите:
   # - allowed_ssh_cidr (ограничьте доступ)
   # - ssh_public_key (добавьте ваш ключ)
   # - project_name (уникальное имя)
   ```

3. **Инициализируйте Terraform:**
   ```bash
   terraform init
   ```

4. **Просмотрите план:**
   ```bash
   terraform plan
   ```

5. **Примените изменения:**
   ```bash
   terraform apply
   ```

## ⚙️ Конфигурация

### Обязательные настройки

```hcl
# Ограничьте SSH доступ
allowed_ssh_cidr = ["10.0.0.0/8", "192.168.1.0/24"]

# Добавьте SSH ключ
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

# Настройте project name
project_name = "my-production-app"
```

### Опциональные настройки

```hcl
# Отключите ALB если не нужен
enable_alb = false

# Отключите S3 backup
enable_s3_backup = false

# Измените retention для логов
log_retention_days = 90
```

## 🔐 Доступ к Production

### Через Load Balancer (рекомендуется)
```bash
# Получите ALB DNS name
terraform output alb_dns_name

# Откройте в браузере
http://[ALB_DNS_NAME]
```

### Прямой доступ к instance
```bash
# Получите Elastic IP
terraform output elastic_ip

# Откройте в браузере
http://[ELASTIC_IP]
```

### SSH доступ
```bash
# Получите команду для подключения
terraform output production_access_info

# Или подключитесь вручную
ssh -i ~/.ssh/id_rsa ec2-user@[ELASTIC_IP]
```

## 📊 Мониторинг

### CloudWatch метрики
- **EC2 метрики**: CPU, Memory, Network, Disk
- **ALB метрики**: Request count, Target response time
- **NAT Gateway метрики**: Bytes sent/received

### Логи
- **Application логи**: `/var/log/app/`
- **Apache логи**: `/var/log/httpd/`
- **User Data логи**: `/var/log/user-data.log`
- **CloudWatch Logs**: `/aws/ec2/[project-name]`

## 💰 Стоимость

### Основные ресурсы
- **EC2 t3.medium**: ~$25-30/месяц
- **EBS gp3 50GB**: ~$5/месяц
- **NAT Gateway**: ~$45/месяц
- **ALB**: ~$20/месяц
- **S3 Storage**: ~$0.023/GB/месяц

### Примерная общая стоимость
- **Без ALB**: ~$75-80/месяц
- **С ALB**: ~$95-100/месяц

**⚠️ Внимание:** NAT Gateway стоит дорого. Рассмотрите альтернативы для dev/staging.

## 🛡️ Безопасность

### Network Security
- EC2 instance в приватной подсети
- NAT Gateway для исходящего трафика
- Security Groups с минимальными правилами
- VPC isolation

### Data Security
- EBS тома зашифрованы
- S3 bucket с шифрованием
- Public access заблокирован
- IAM roles и policies

### Access Control
- Ограниченный SSH доступ
- Key-based authentication
- CloudTrail для аудита
- AWS Config для compliance

## 🔄 Обновления и Maintenance

### Обновление instance
```bash
# Обновите AMI ID в terraform.tfvars
# Запустите terraform plan
# Примените изменения
terraform apply
```

### Backup и восстановление
- S3 bucket с versioning
- EBS snapshots (можно добавить)
- AMI creation (можно добавить)

### Scaling
- Добавьте Auto Scaling Group
- Используйте multiple AZ
- Добавьте RDS для базы данных

## 🚨 Troubleshooting

### Частые проблемы

1. **NAT Gateway не работает**
   - Проверьте route table associations
   - Убедитесь что public subnet имеет IGW route

2. **Instance недоступен**
   - Проверьте security group rules
   - Убедитесь что NAT Gateway работает
   - Проверьте route table для приватной подсети

3. **ALB health checks fail**
   - Проверьте security group rules
   - Убедитесь что web server работает
   - Проверьте target group configuration

### Полезные команды

```bash
# Проверить NAT Gateway
aws ec2 describe-nat-gateways --nat-gateway-ids [NAT_ID]

# Проверить route tables
aws ec2 describe-route-tables --route-table-ids [RT_ID]

# Проверить ALB health
aws elbv2 describe-target-health --target-group-arn [TG_ARN]

# Проверить CloudWatch logs
aws logs describe-log-streams --log-group-name "/aws/ec2/[project-name]"
```

## 🧹 Очистка

### Удаление ресурсов
```bash
terraform destroy
```

**⚠️ Внимание:** Это удалит ВСЕ ресурсы, включая production данные!

### Безопасное удаление
1. Сделайте backup важных данных
2. Создайте AMI snapshot
3. Экспортируйте конфигурацию
4. Запустите destroy

## 📚 Дополнительные ресурсы

### AWS Documentation
- [VPC with Public and Private Subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html)
- [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)
- [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)

### Terraform Documentation
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

### Best Practices
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🆘 Поддержка

При возникновении проблем:
1. Проверьте CloudWatch логи
2. Изучите AWS CloudTrail
3. Проверьте Terraform state
4. Создайте issue в репозитории

---

**🚀 Готово к production!** Этот пример демонстрирует enterprise-grade инфраструктуру, готовую для production использования.
