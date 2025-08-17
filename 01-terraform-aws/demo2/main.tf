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
    region = "eu-north-1"   # region בקנדה
}

# יצירת VPC חדש עם CIDR Block של /16 – כלומר רשת פרטית עם טווח גדול של כתובות
resource "aws_vpc" "vpc_demo" {
    cidr_block = "10.0.0.0/16"    # טווח כתובות פרטי
    tags = {
      "Name" = "demo1-vpc"
      "Framework" = "terraform"        # תגית (שם) לזיהוי ה-VPC
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
resource "aws_instance" "public_linux" {
    ami           = "ami-0abf2a9d461524a30" # מזהה של מערכת הפעלה (Ubuntu)
    instance_type = "t3.micro"              # סוג המכונה (קטנה וזולה)
    subnet_id     = aws_subnet.subnet1.id   # שייכת ל-Subnet שהגדרנו
    key_name = "alexey-demo"             # מפתח SSH לגישה לשרת
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

resource "aws_internet_gateway" "igw_demo" {
  vpc_id = aws_vpc.vpc_demo.id
  tags = {
    Name = "demo1"
  }
}

resource "aws_route_table" "rt_demo" {
  vpc_id = aws_vpc.vpc_demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_demo.id
  }
  tags = {
    Name = "demo1"
  }
}

resource "aws_route_table_association" "rta_demo" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt_demo.id
}

