# Network Information
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.ec2_complete.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.ec2_complete.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.ec2_complete.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.ec2_complete.private_subnet_id
}

# EC2 Instance Information
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_complete.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_complete.instance_public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2_complete.instance_private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = module.ec2_complete.instance_public_dns
}

# Security Information
output "security_group_id" {
  description = "ID of the security group"
  value       = module.ec2_complete.security_group_id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = module.ec2_complete.security_group_name
}

# SSH Access Information
output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = module.ec2_complete.key_pair_name
}

# Web Application Access
output "web_url" {
  description = "URL to access the web application"
  value       = "http://${module.ec2_complete.instance_public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${module.ec2_complete.instance_public_ip}"
}

# Network Route Information
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.ec2_complete.public_route_table_id
}

# Availability Zone
output "availability_zone" {
  description = "Availability zone used for deployment"
  value       = module.ec2_complete.availability_zone
}

# Summary Information
output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    project_name     = var.project_name
    environment      = var.environment
    instance_type    = var.instance_type
    vpc_cidr         = var.vpc_cidr
    public_subnet    = var.public_subnet_cidr
    private_subnet   = var.private_subnet_cidr
    deploy_location  = var.deploy_in_private ? "Private Subnet" : "Public Subnet"
    monitoring       = var.enable_monitoring ? "Enabled" : "Disabled"
    volume_size      = "${var.root_volume_size}GB"
    volume_type      = var.root_volume_type
    encryption       = "Enabled"
  }
}
