הבנתי אותך — לתרגיל שני נרחיב את הידע מהתרגיל הראשון וניצור **VPC מותאם אישית**, ואז נריץ עליו **EC2 Instance**.
הנה מדריך ב־Markdown שיכול לשמש ישירות כחומר לתלמידים:

````markdown
# 🌐 תרגיל 2 – יצירת VPC מותאם אישית + שרת EC2 ב-Terraform

בתרגיל זה נלמד להקים **רשת פרטית (VPC)** משלנו בענן AWS, להוסיף לה תת-רשת (Subnet), שער גישה לאינטרנט (Internet Gateway), חוקים ב-Route Table, ואז ניצור שרת EC2 בתוכה.

---

## 📋 דרישות מוקדמות
לפני שמתחילים ודאו שיש לכם:
- Terraform מותקן
- חשבון AWS + גישה דרך AWS CLI (כמו בתרגיל הראשון)
- הבנה בסיסית בקבצי Terraform (`.tf`)

---

## 🛠 שלב 1 – יצירת תיקיית פרויקט חדשה
```bash
mkdir terraform-vpc
cd terraform-vpc
````

---

## 🛠 שלב 2 – קובץ ספק (Provider)

`provider.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

## 🛠 שלב 3 – יצירת VPC

`vpc.tf`

```hcl
# יצירת VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyTerraformVPC"
  }
}
```

---

## 🛠 שלב 4 – יצירת Subnet

```hcl
# תת-רשת ציבורית
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "PublicSubnet"
  }
}
```

---

## 🛠 שלב 5 – יצירת Internet Gateway

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}
```

---

## 🛠 שלב 6 – יצירת Route Table

```hcl
# טבלת ניתוב
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# קישור הטבלה ל-Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
```

---

## 🛠 שלב 7 – יצירת Security Group

```hcl
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSG"
  }
}
```

---

## 🛠 שלב 8 – יצירת EC2 בתוך ה-VPC

```hcl
resource "aws_instance" "web_server" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "VPC-WebServer"
  }
}
```

---

## 🛠 שלב 9 – הרצה

```bash
terraform init
terraform plan
terraform apply
```

> הקלידו `yes` לאישור.

---

## 🛠 שלב 10 – בדיקה

* התחברו ל-[AWS Console](https://console.aws.amazon.com/ec2/).
* בדקו שקיימת **VPC** בשם `MyTerraformVPC`.
* ודאו שקיים שרת EC2 ב-Subnet שיצרתם.

---

## 🛠 שלב 11 – ניקוי משאבים

```bash
terraform destroy
```

---

## 📌 מה למדנו?

* איך ליצור **VPC מותאם אישית**.
* איך להוסיף **Subnet, Internet Gateway, Route Table**.
* איך ליצור **Security Group** ולהפעיל עליו EC2 Instance.
* איך לעבוד בצורה מודולרית עם קבצי Terraform.

---

💡 **טיפ**: בתרגילים הבאים נוכל להוסיף גם **Load Balancer**, **Auto Scaling** ועוד.

```

אם תרצה, אני יכול להכין גרסה משולבת שבה **תרגיל 1 + תרגיל 2** יהיו באותו פרויקט, כדי שהתלמידים יראו איך מתחילים בסיס קטן ואז בונים עליו רשת אמיתית.  
האם תרצה שאכין גם את זה?
```
