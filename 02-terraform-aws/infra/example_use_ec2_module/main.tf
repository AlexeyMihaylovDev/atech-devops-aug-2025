# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Use the EC2 Complete Module
module "ec2_complete" {
  source = "../modules/ec2-complete"
  
  project_name = var.project_name
  ami_id       = var.ami_id
  instance_type = var.instance_type
  
  # VPC Configuration
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone = var.availability_zone
  
  # Security Configuration
  allowed_ssh_cidr = var.allowed_ssh_cidr
  allowed_http_cidr = var.allowed_http_cidr
  
  # Storage Configuration
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  encrypt_volumes = var.encrypt_volumes
  
  # Deployment Configuration
  deploy_in_private = var.deploy_in_private
  enable_monitoring = var.enable_monitoring
  
  # User Data - устанавливаем веб-сервер
  user_data = var.user_data
  
  # Tags
  common_tags = var.common_tags
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
