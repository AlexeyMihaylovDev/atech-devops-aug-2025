# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Use the EC2 Complete Module
module "ec2_complete" {
  source = "../"
  
  project_name = "webapp-demo"
  ami_id       = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t3.micro"
  
  # VPC Configuration
  vpc_cidr = "172.16.0.0/16"
  public_subnet_cidr = "172.16.1.0/24"
  private_subnet_cidr = "172.16.2.0/24"
  availability_zone = "us-east-1a"
  
  # Security Configuration
  allowed_ssh_cidr = ["0.0.0.0/0"]  # В продакшене ограничьте доступ
  allowed_http_cidr = ["0.0.0.0/0"]
  
  # Storage Configuration
  root_volume_size = 30
  root_volume_type = "gp3"
  encrypt_volumes = true
  
  # Deployment Configuration
  deploy_in_private = false  # Развертываем в публичной подсети для демо
  enable_monitoring = true
  
  # User Data - устанавливаем веб-сервер
  user_data = <<-EOF
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
  
  # Tags
  common_tags = {
    Environment = "demo"
    Project     = "terraform-module-demo"
    Owner       = "devops-team"
    Purpose     = "learning"
  }
}

# Output values
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.ec2_complete.vpc_id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2_complete.instance_public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2_complete.instance_public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.ec2_complete.security_group_id
}

output "web_url" {
  description = "URL to access the web application"
  value       = "http://${module.ec2_complete.instance_public_ip}"
}
