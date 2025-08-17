# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "webapp-demo"
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
  
  validation {
    condition     = contains(["dev", "staging", "prod", "demo"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, demo."
  }
}

# Instance Configuration
variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
  
  validation {
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "AMI ID must start with 'ami-'."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition     = can(regex("^t3\\.", var.instance_type)) || can(regex("^t2\\.", var.instance_type))
    error_message = "Instance type should be t2 or t3 family for cost optimization."
  }
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "172.16.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "172.16.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "us-east-1a"
}

# Security Configuration
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
  validation {
    condition     = length(var.allowed_ssh_cidr) > 0
    error_message = "At least one SSH CIDR block must be specified."
  }
}

variable "allowed_http_cidr" {
  description = "CIDR blocks allowed for HTTP/HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Storage Configuration
variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
  
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 100
    error_message = "Root volume size must be between 8 and 100 GB."
  }
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
  
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "encrypt_volumes" {
  description = "Enable encryption for EBS volumes"
  type        = bool
  default     = true
}

# Deployment Configuration
variable "deploy_in_private" {
  description = "Deploy EC2 in private subnet"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script for EC2 instance"
  type        = string
  default     = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Создаем простую веб-страницу
              cat > /var/www/html/index.html << 'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Terraform EC2 Demo</title>
                  <style>
                      body { font-family: Arial, sans-serif; margin: 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
                      .container { max-width: 800px; margin: 0 auto; text-align: center; }
                      h1 { font-size: 3em; margin-bottom: 20px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
                      .info { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; margin: 20px 0; }
                      .status { background: rgba(76, 175, 80, 0.2); padding: 15px; border-radius: 8px; margin: 10px 0; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🚀 Terraform EC2 Demo</h1>
                      <div class="info">
                          <h2>Инфраструктура успешно развернута!</h2>
                          <p>Этот EC2 instance был создан с помощью Terraform модуля</p>
                      </div>
                      <div class="status">
                          <h3>✅ Статус: Работает</h3>
                          <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
                          <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
                          <p>Время запуска: $(date)</p>
                      </div>
                      <div class="info">
                          <h3>🛠️ Что включено:</h3>
                          <ul style="list-style: none; padding: 0;">
                              <li>✓ VPC с публичной и приватной подсетями</li>
                              <li>✓ Internet Gateway</li>
                              <li>✓ Security Groups</li>
                              <li>✓ SSH Key Pair</li>
                              <li>✓ EBS Volume с шифрованием</li>
                              <li>✓ Apache Web Server</li>
                          </ul>
                      </div>
                  </div>
              </body>
              </html>
              HTML
              
              # Устанавливаем дополнительные пакеты
              yum install -y curl wget
              
              # Логируем успешное завершение
              echo "Web server setup completed at $(date)" >> /var/log/user-data.log
              EOF
}

# Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "demo"
    Project     = "terraform-module-demo"
    Owner       = "devops-team"
    Purpose     = "learning"
    ManagedBy   = "terraform"
  }
}
