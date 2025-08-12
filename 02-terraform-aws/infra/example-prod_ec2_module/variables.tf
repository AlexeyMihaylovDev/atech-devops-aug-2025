# AWS Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "production-webapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["production", "staging"], var.environment)
    error_message = "Environment must be production or staging."
  }
}

# Instance Configuration
variable "instance_type" {
  description = "EC2 instance type for production"
  type        = string
  default     = "t3.medium"
  
  validation {
    condition     = can(regex("^t3\\.", var.instance_type)) || can(regex("^m5\\.", var.instance_type)) || can(regex("^c5\\.", var.instance_type))
    error_message = "Instance type should be t3, m5, or c5 family for production workloads."
  }
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "us-east-1a"
}

# Security Configuration
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access (restricted for production)"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.1.0/24"]  # Ограниченный доступ
  
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

variable "ssh_public_key" {
  description = "SSH public key for EC2 instance"
  type        = string
  default     = ""
}

# Storage Configuration
variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 50
  
  validation {
    condition     = var.root_volume_size >= 20 && var.root_volume_size <= 500
    error_message = "Root volume size must be between 20 and 500 GB for production."
  }
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
  
  validation {
    condition     = contains(["gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Volume type must be gp3, io1, or io2 for production."
  }
}

variable "encrypt_volumes" {
  description = "Whether to encrypt EBS volumes"
  type        = bool
  default     = true
}

# Production Features
variable "enable_alb" {
  description = "Enable Application Load Balancer"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = true
}

variable "enable_s3_backup" {
  description = "Enable S3 bucket for application data backup"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
  
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention must be one of the allowed values."
  }
}

# User Data
variable "user_data" {
  description = "User data script for production EC2 instance"
  type        = string
  default     = ""
}

# Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "production-webapp"
    Owner       = "devops-team"
    Purpose     = "production"
    ManagedBy   = "terraform"
    CostCenter  = "production"
    Compliance  = "high"
  }
}
