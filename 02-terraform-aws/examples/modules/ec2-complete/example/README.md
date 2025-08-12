# Пример использования EC2 Complete Module

Этот пример демонстрирует, как использовать модуль `ec2-complete` для создания полноценной инфраструктуры EC2.

## Что создается

При запуске этого примера будет создана следующая инфраструктура:

- **VPC** с CIDR блоком `172.16.0.0/16`
- **Публичная подсеть** `172.16.1.0/24` в зоне `us-east-1a`
- **Приватная подсеть** `172.16.2.0/24` в зоне `us-east-1a`
- **Internet Gateway** для доступа к интернету
- **Route Table** с маршрутом к интернету
- **Security Group** с правилами для SSH, HTTP и HTTPS
- **SSH Key Pair** для доступа к instance
- **EC2 Instance** типа `t3.micro` с Amazon Linux 2
- **EBS Volume** размером 30GB с шифрованием
- **Веб-сервер Apache** с красивой демо-страницей

## Быстрый старт

### Предварительные требования

1. **AWS CLI** настроен с соответствующими правами
2. **Terraform** версии 1.0 или выше
3. **SSH ключ** (если планируете подключаться по SSH)

### Шаги для запуска

1. **Перейдите в папку примера:**
   ```bash
   cd 02-terraform-aws/examples/modules/ec2-complete/example
   ```

2. **Инициализируйте Terraform:**
   ```bash
   terraform init
   ```

3. **Просмотрите план изменений:**
   ```bash
   terraform plan
   ```

4. **Примените изменения:**
   ```bash
   terraform apply
   ```

5. **Подтвердите создание ресурсов:**
   Введите `yes` когда Terraform спросит о подтверждении.

### Доступ к веб-приложению

После успешного развертывания:

1. **Получите публичный IP:**
   ```bash
   terraform output instance_public_ip
   ```

2. **Откройте в браузере:**
   ```
   http://[PUBLIC_IP]
   ```

3. **Или используйте готовый URL:**
   ```bash
   terraform output web_url
   ```

## Настройка

### Изменение конфигурации

Отредактируйте файл `terraform.tfvars` для изменения параметров:

```hcl
# Изменить тип instance
instance_type = "t3.small"

# Изменить размер диска
root_volume_size = 50

# Развернуть в приватной подсети
deploy_in_private = true

# Ограничить SSH доступ
allowed_ssh_cidr = ["10.0.0.0/8", "192.168.1.0/24"]
```

### Добавление SSH ключа

Если у вас есть SSH ключ, добавьте его в `terraform.tfvars`:

```hcl
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
```

Или создайте новый ключ:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/terraform-demo
```

## Подключение по SSH

После развертывания подключитесь к instance:

```bash
# Получите команду для подключения
terraform output ssh_command

# Или подключитесь вручную
ssh -i ~/.ssh/id_rsa ec2-user@[PUBLIC_IP]
```

## Мониторинг и логи

- **CloudWatch мониторинг** включен по умолчанию
- **User Data логи** доступны в `/var/log/user-data.log`
- **Apache логи** в `/var/log/httpd/`

## Очистка ресурсов

Для удаления всех созданных ресурсов:

```bash
terraform destroy
```

**⚠️ Внимание:** Это удалит все ресурсы, включая данные на EBS томах.

## Структура файлов

```
example/
├── main.tf              # Основная конфигурация
├── variables.tf         # Определение переменных
├── outputs.tf           # Выходные значения
├── versions.tf          # Версии Terraform и провайдеров
├── terraform.tfvars     # Значения переменных
└── README.md            # Этот файл
```

## Troubleshooting

### Частые проблемы

1. **Ошибка "AMI not found"**
   - Убедитесь, что AMI ID актуален для вашего региона
   - Используйте AWS Systems Manager Parameter Store для получения актуальных AMI

2. **Ошибка "VPC CIDR conflict"**
   - Измените CIDR блоки в `terraform.tfvars`
   - Убедитесь, что они не пересекаются с существующими VPC

3. **Instance не запускается**
   - Проверьте security group правила
   - Убедитесь, что user data скрипт корректный

### Полезные команды

```bash
# Проверить статус instance
aws ec2 describe-instances --instance-ids [INSTANCE_ID]

# Просмотреть security group правила
aws ec2 describe-security-groups --group-ids [SG_ID]

# Проверить логи user data
aws logs describe-log-groups --log-group-name-prefix "/aws/ec2"
```

## Безопасность

⚠️ **Важно для продакшена:**

- Ограничьте `allowed_ssh_cidr` только необходимыми IP
- Используйте приватные подсети для production
- Включите CloudTrail для аудита
- Настройте AWS Config для compliance
- Используйте AWS Secrets Manager для sensitive данных

## Стоимость

Примерная стоимость ресурсов (us-east-1):
- **EC2 t3.micro**: ~$8-10/месяц
- **EBS gp3 30GB**: ~$3/месяц
- **VPC и подсети**: бесплатно
- **Data Transfer**: зависит от использования

**Итого**: ~$11-13/месяц

## Поддержка

При возникновении вопросов:
1. Проверьте логи Terraform
2. Изучите AWS CloudTrail
3. Создайте issue в репозитории проекта
