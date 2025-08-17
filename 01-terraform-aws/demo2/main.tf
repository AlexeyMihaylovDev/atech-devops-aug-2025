terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # מציין שמשתמשים בפרוביידר AWS הרשמי של HashiCorp
      version = "5.45.0"          # גרסת הפרוביידר – כדי להבטיח תאימות
    }
  }
}

# הגדרה של פרוביידר AWS – כאן מגדירים באיזה region נשתמש
provider "aws" {
    region = "ca-central-1"   # region בקנדה
}

# יצירת VPC חדש עם CIDR Block של /16 – כלומר רשת פרטית עם טווח גדול של כתובות
resource "aws_vpc" "vpc_demo" {
    cidr_block = "10.0.0.0/16"    # טווח כתובות פרטי
    tags = {
      "Name" = "demo1-vpc"        # תגית (שם) לזיהוי ה-VPC
    }
}

# יצירת Subnet בתוך ה-VPC שהגדרנו
resource "aws_subnet" "subnet1" {
    vpc_id     = aws_vpc.vpc_demo.id   # שייך ל-VPC שיצרנו
    cidr_block = "10.0.1.0/24"         # טווח כתובות קטן יותר מתוך ה-VPC
    tags = {
      "Name" = "demo1"                 # תגית לזיהוי ה-Subnet
    }
    depends_on = [ aws_vpc.vpc_demo ]  # תלות – יוודא שה-VPC יווצר קודם
}

# יצירת מכונה וירטואלית (EC2 instance) בתוך ה-Subnet
resource "aws_instance" "ubuntu_public_linux_1" {
    ami           = "ami-05d4121edd74a9f06" # מזהה של מערכת הפעלה (Ubuntu)
    instance_type = "t2.micro"              # סוג המכונה (קטנה וזולה)
    subnet_id     = aws_subnet.subnet1.id   # שייכת ל-Subnet שהגדרנו
    key_name = "demo1"             # מפתח SSH לגישה לשרת
    associate_public_ip_address = true      # הקצאת כתובת ציבורית לשרת
    vpc_security_group_ids = [aws_security_group.secure-group_demo.id] # שיוך ל-SG

    tags = {
        Name = "demo1"                      # שם/תגית לשרת
    }
}

# יצירת Security Group (חומת אש) עבור השרתים
resource "aws_security_group" "secure-group_demo" {
  name        = "web_server_secure_group"   # שם קבוצת האבטחה
  description = "Allow TLS inbound traffic" # תיאור קצר
  vpc_id      = aws_vpc.vpc_demo.id         # שייכת ל-VPC

  # חוקים נכנסים (Ingress) – פתיחת פורטים ספציפיים
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "8081", "9000"] # לולאה על רשימת פורטים
    content {
      from_port   = ingress.value   # פורט התחלה
      to_port     = ingress.value   # פורט סיום (אותו פורט בודד)
      protocol    = "tcp"           # פרוטוקול TCP
      cidr_blocks = ["0.0.0.0/0"]   # פתוח לכל העולם
    }
  }

  # כלל מיוחד ל-SSH (פורט 22) כדי שנוכל להתחבר לשרת
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]     # פתוח מכל כתובת (בפועל עדיף להגביל)
  }

  # חוקים יוצאים (Egress) – מאפשרים יציאה לכל פורט ופרוטוקול
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"              # כל הפרוטוקולים
    cidr_blocks = ["0.0.0.0/0"]     # לכל כתובת
  }

  tags = {
      Name = "demo1"                # תגית לזיהוי קבוצת האבטחה
  }
}
