############################################################
# תיעוד: יצירת VPC, Subnet, Security Group ו-EC2 Instance
#
# 🎯 מטרת התרגיל
# יצירת תשתית בסיסית ב-AWS:
# - VPC (Virtual Private Cloud)
# - Subnet בתוך ה-VPC
# - Security Group (חומת אש)
# - EC2 Instance (שרת Ubuntu)
############################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # שימוש בפרוביידר AWS הרשמי
      version = "5.45.0"          # גרסת פרוביידר
    }
  }
}

# פרוביידר AWS – מגדיר Region
provider "aws" {
  region = "ca-central-1"   # Canada
}

############################################################
# יצירת VPC
############################################################
resource "aws_vpc" "vpc_demo" {
  cidr_block = "10.0.0.0/16"       # טווח כתובות IP פרטי
  tags = {
    "Name" = "demo1-vpc"           # שם ה-VPC
  }
}

############################################################
# יצירת Subnet
############################################################
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc_demo.id # שיוך ל-VPC
  cidr_block = "10.0.1.0/24"       # טווח קטן מתוך ה-VPC
  tags = {
    "Name" = "demo1"
  }
  depends_on = [ aws_vpc.vpc_demo ] # יוודא שה-VPC נוצר קודם
}

############################################################
# יצירת Security Group (חומת אש)
############################################################
resource "aws_security_group" "secure-group_demo" {
  name        = "web_server_secure_group"   # שם קבוצת האבטחה
  description = "Allow inbound traffic"     # תיאור
  vpc_id      = aws_vpc.vpc_demo.id         # שיוך ל-VPC

  # חוקים נכנסים (Ingress) – פורטים נפוצים ל-Web
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "8081", "9000"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]   # פתוח לכל העולם
    }
  }

  # פורט SSH (22) לגישה לשרת
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # חוקים יוצאים (Egress) – כל התעבורה מותרת
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"              # כל הפרוטוקולים
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo1"
  }
}

############################################################
# יצירת מכונה EC2
############################################################
resource "aws_instance" "ubuntu_public_linux_1" {
  ami           = "ami-05d4121edd74a9f06" # Ubuntu
  instance_type = "t2.micro"              # סוג מכונה
  subnet_id     = aws_subnet.subnet1.id   # שיוך ל-Subnet
  key_name      = "polybot_master"        # מפתח SSH
  associate_public_ip_address = true      # כתובת ציבורית
  vpc_security_group_ids      = [aws_security_group.secure-group_demo.id]

  tags = {
    Name = "demo1"
  }
}

############################################################
# תרשים ארכיטקטורה (Mermaid) – להסבר ויזואלי
#
# graph TD
#     A[VPC 10.0.0.0/16] --> B[Subnet 10.0.1.0/24]
#     B --> C[EC2 Instance: Ubuntu t2.micro]
#     C --> D[Security Group: web_server_secure_group]
#     
#     D -->|Ingress| C1[80 HTTP]
#     D -->|Ingress| C2[443 HTTPS]
#     D -->|Ingress| C3[8080, 8081, 9000]
#     D -->|Ingress| C4[22 SSH]
#     D -->|Egress| E[All Traffic 0.0.0.0/0]
#
############################################################

# 🚀 איך להריץ?
# terraform init
# terraform plan
# terraform apply
