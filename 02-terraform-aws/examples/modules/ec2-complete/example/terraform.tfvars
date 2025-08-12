# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "webapp-demo"
environment  = "demo"

# Instance Configuration
instance_type = "t3.micro"

# Network Configuration
vpc_cidr             = "172.16.0.0/16"
public_subnet_cidr   = "172.16.1.0/24"
private_subnet_cidr  = "172.16.2.0/24"
availability_zone    = "us-east-1a"

# Security Configuration
allowed_ssh_cidr  = ["0.0.0.0/0"]  # В продакшене ограничьте доступ
allowed_http_cidr = ["0.0.0.0/0"]

# Storage Configuration
root_volume_size = 30
root_volume_type = "gp3"

# Deployment Configuration
deploy_in_private = false  # Развертываем в публичной подсети для демо
enable_monitoring = true

# Tags
common_tags = {
  Environment = "demo"
  Project     = "terraform-module-demo"
  Owner       = "devops-team"
  Purpose     = "learning"
  ManagedBy   = "terraform"
  CostCenter  = "devops-training"
}
