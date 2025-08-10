# Лабораторная работа 1: Базовая инфраструктура AWS

## Цель
Создать базовую инфраструктуру AWS с помощью Terraform: VPC, подсети, EC2 инстанс.

## Задачи

### Задача 1: Подготовка окружения
1. Установите Terraform:
```bash
# Linux
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# macOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

2. Установите AWS CLI и настройте credentials:
```bash
aws configure
```

### Задача 2: Создание базовой конфигурации
Создайте файл `main.tf` со следующей конфигурацией:

```hcl
# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Data source for latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create security group
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              EOF

  tags = {
    Name = "web-server"
  }
}

# Output the public IP
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### Задача 3: Развертывание инфраструктуры
1. Инициализируйте Terraform:
```bash
terraform init
```

2. Просмотрите план изменений:
```bash
terraform plan
```

3. Примените изменения:
```bash
terraform apply
```

4. Проверьте, что ресурсы созданы:
```bash
terraform show
```

### Задача 4: Тестирование
1. Получите public IP инстанса:
```bash
terraform output public_ip
```

2. Проверьте доступность веб-сервера:
```bash
curl http://<public_ip>
```

### Задача 5: Очистка
Удалите созданную инфраструктуру:
```bash
terraform destroy
```

## Критерии оценки

- [ ] Terraform установлен и настроен
- [ ] AWS credentials настроены
- [ ] VPC создана с правильными настройками
- [ ] Public subnet создана
- [ ] Internet Gateway настроен
- [ ] Security Group создана с правильными правилами
- [ ] EC2 инстанс запущен
- [ ] Веб-сервер доступен
- [ ] Инфраструктура успешно удалена

## Дополнительные задания

1. Добавьте private subnet
2. Создайте NAT Gateway для private subnet
3. Добавьте второй EC2 инстанс в private subnet
4. Настройте Application Load Balancer

## Время выполнения: 45 минут
