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
  description = "ID of the EC2 security group"
  value       = module.ec2_complete.security_group_id
}

output "security_group_name" {
  description = "Name of the EC2 security group"
  value       = module.ec2_complete.security_group_name
}

# SSH Access Information
output "key_pair_name" {
  description = "Name of the SSH key pair"
  value       = module.ec2_complete.key_pair_name
}

# Elastic IP Information
output "elastic_ip" {
  description = "Elastic IP address for the EC2 instance"
  value       = module.ec2_complete.elastic_ip
}

# NAT Gateway Information
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# Load Balancer Information (if enabled)
output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].id : null
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].dns_name : null
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.main[0].arn : null
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = var.enable_alb ? aws_lb_target_group.main[0].arn : null
}

# Route Table Information
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.ec2_complete.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

# CloudWatch Log Group
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.arn
}

# S3 Bucket Information (if enabled)
output "s3_bucket_name" {
  description = "Name of the S3 bucket for application data"
  value       = var.enable_s3_backup ? aws_s3_bucket.app_data[0].bucket : null
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for application data"
  value       = var.enable_s3_backup ? aws_s3_bucket.app_data[0].arn : null
}

# Availability Zone
output "availability_zone" {
  description = "Availability zone used for deployment"
  value       = module.ec2_complete.availability_zone
}

# Production Access Information
output "production_access_info" {
  description = "Information for accessing the production environment"
  value = {
    instance_id        = module.ec2_complete.instance_id
    private_ip         = module.ec2_complete.instance_private_ip
    elastic_ip         = module.ec2_complete.elastic_ip
    nat_gateway_ip     = aws_eip.nat.public_ip
    alb_dns_name       = var.enable_alb ? aws_lb.main[0].dns_name : "Not enabled"
    ssh_command        = "ssh -i ~/.ssh/id_rsa ec2-user@${module.ec2_complete.elastic_ip}"
    web_url_alb        = var.enable_alb ? "http://${aws_lb.main[0].dns_name}" : "Load balancer not enabled"
    web_url_direct     = "http://${module.ec2_complete.elastic_ip}"
  }
}

# Security Summary
output "security_summary" {
  description = "Security configuration summary"
  value = {
    vpc_cidr           = var.vpc_cidr
    public_subnet      = var.public_subnet_cidr
    private_subnet     = var.private_subnet_cidr
    ssh_access         = var.allowed_ssh_cidr
    http_access        = var.allowed_http_cidr
    encryption_enabled = var.encrypt_volumes
    private_deployment = true
    nat_gateway        = true
    security_groups    = [module.ec2_complete.security_group_id]
  }
}

# Infrastructure Summary
output "infrastructure_summary" {
  description = "Complete infrastructure summary"
  value = {
    project_name       = var.project_name
    environment        = var.environment
    instance_type      = var.instance_type
    storage_size       = "${var.root_volume_size}GB"
    storage_type       = var.root_volume_type
    monitoring         = var.enable_monitoring
    load_balancer      = var.enable_alb
    s3_backup          = var.enable_s3_backup
    log_retention      = "${var.log_retention_days} days"
    deletion_protection = var.enable_deletion_protection
    compliance_level   = "high"
    estimated_cost     = "~$50-80/month (including NAT Gateway)"
  }
}
