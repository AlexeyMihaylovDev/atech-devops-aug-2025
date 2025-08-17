# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Use the EC2 Complete Module for Production
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
  
  # Security Configuration - Production Security
  allowed_ssh_cidr = var.allowed_ssh_cidr  # Ограниченный доступ
  allowed_http_cidr = var.allowed_http_cidr
  ssh_public_key = var.ssh_public_key
  
  # Storage Configuration
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  encrypt_volumes = var.encrypt_volumes
  
  # Deployment Configuration - Production in Private Subnet
  deploy_in_private = true  # Развертываем в приватной подсети
  enable_monitoring = true
  
  # User Data - Production Web Server Setup
  user_data = var.user_data
  
  # Tags
  common_tags = var.common_tags
}

# Additional Production Resources

# NAT Gateway for Private Subnet Internet Access
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-eip"
    Purpose = "NAT Gateway"
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = module.ec2_complete.public_subnet_id
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-nat-gateway"
    Purpose = "Internet Access for Private Subnet"
  })
  
  depends_on = [module.ec2_complete]
}

# Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = module.ec2_complete.vpc_id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-private-rt"
    Purpose = "Private Subnet Routing"
  })
}

# Route Table Association for Private Subnet
resource "aws_route_table_association" "private" {
  subnet_id      = module.ec2_complete.private_subnet_id
  route_table_id = aws_route_table.private.id
}

# Additional Security Group for Production
resource "aws_security_group" "production_alb" {
  count       = var.enable_alb ? 1 : 0
  name_prefix = "${var.project_name}-alb-sg"
  vpc_id      = module.ec2_complete.vpc_id
  
  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }
  
  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }
  
  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-alb-sg"
    Purpose = "Application Load Balancer"
  })
}

# Application Load Balancer (Optional)
resource "aws_lb" "main" {
  count              = var.enable_alb ? 1 : 0
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.production_alb[0].id]
  subnets            = [module.ec2_complete.public_subnet_id]
  
  enable_deletion_protection = var.enable_deletion_protection
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-alb"
    Purpose = "Production Load Balancer"
  })
}

# ALB Target Group
resource "aws_lb_target_group" "main" {
  count       = var.enable_alb ? 1 : 0
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.ec2_complete.vpc_id
  target_type = "instance"
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-target-group"
  })
}

# ALB Target Group Attachment
resource "aws_lb_target_group_attachment" "main" {
  count            = var.enable_alb ? 1 : 0
  target_group_arn = aws_lb_target_group.main[0].arn
  target_id        = module.ec2_complete.instance_id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "main" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-listener"
  })
}

# CloudWatch Log Group for Application Logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ec2/${var.project_name}"
  retention_in_days = var.log_retention_days
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-app-logs"
    Purpose = "Application Logging"
  })
}

# S3 Bucket for Application Data (Optional)
resource "aws_s3_bucket" "app_data" {
  count  = var.enable_s3_backup ? 1 : 0
  bucket = "${var.project_name}-app-data-${random_string.bucket_suffix[0].result}"
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-app-data"
    Purpose = "Application Data Storage"
  })
}

# Random string for unique bucket names
resource "random_string" "bucket_suffix" {
  count   = var.enable_s3_backup ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "app_data" {
  count  = var.enable_s3_backup ? 1 : 0
  bucket = aws_s3_bucket.app_data[0].id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  count  = var.enable_s3_backup ? 1 : 0
  bucket = aws_s3_bucket.app_data[0].id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "app_data" {
  count  = var.enable_s3_backup ? 1 : 0
  bucket = aws_s3_bucket.app_data[0].id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
