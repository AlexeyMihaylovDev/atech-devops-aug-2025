# 🗂 עבודה עם tfvars – ניהול משתנים ב-Terraform

---

## 📖 מה זה tfvars?
ב-Terraform ניתן להגדיר **משתנים (Variables)** כדי שהקוד שלנו יהיה גמיש וקל לשינוי.  
קובץ `terraform.tfvars` מאפשר לנו **להזין ערכים למשתנים** בצורה נפרדת מהקוד, כך שלא נצטרך לערוך את קבצי ה־`.tf` בכל פעם.

---

## 💡 למה להשתמש ב-tfvars?
- **גמישות** – שינוי ערכים בלי לגעת בקוד.
- **שימוש חוזר** – ניתן להפעיל את אותו קוד עם פרמטרים שונים (סביבות שונות).
- **סודיות** – ניתן לשמור סיסמאות ומפתחות גישה מחוץ לקוד (בשילוב עם `.gitignore`).
- **ניהול מסודר** – כל המשתנים במקום אחד.

---

## 🛠 מבנה השימוש
1. יוצרים **קובץ משתנים** (`variables.tf`) – מגדירים שמות, סוגים ותיאורים.
2. יוצרים **קובץ ערכים** (`terraform.tfvars`) – ממלאים את הערכים בפועל.
3. משתמשים במשתנים בקובצי ה־Terraform.
4. משתמשים ב-**Data Sources** לקבלת מידע דינמי מ-AWS.

---

## 📦 דוגמה – תשתית מלאה עם tfvars ו-Data Sources

### 1️⃣ הגדרת משתנים – `variables.tf`
```hcl
variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
}
```

---

### 2️⃣ קובץ ערכים – `terraform.tfvars`
```hcl
aws_region    = "eu-north-1"
instance_type = "t2.micro"
key_name      = "my-keypair"
```

---

### 3️⃣ קובץ ספק ו-Data Sources – `provider.tf`
```hcl
provider "aws" {
  region = var.aws_region
}

# Data source לקבלת Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source לקבלת Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

---

### 4️⃣ קובץ תשתית – `main.tf`
```hcl
# יצירת VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo-vpc"
  }
}

# יצירת Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

# יצירת Subnet ציבורי
resource "aws_subnet" "demo_subnet" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-subnet"
  }
}

# יצירת Route Table
resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo-rt"
  }
}

# קישור Route Table ל-Subnet
resource "aws_route_table_association" "demo_rta" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_rt.id
}

# יצירת Security Group
resource "aws_security_group" "demo_sg" {
  name        = "demo-security-group"
  description = "Security group for demo EC2 instance"
  vpc_id      = aws_vpc.demo_vpc.id

  # SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-sg"
  }
}

# יצירת EC2 Instance
resource "aws_instance" "demo_ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]

  tags = {
    Name = "demo-ec2"
  }
}
```

---

## 🧪 תרגיל לסטודנטים

**מטרה:** להקים תשתית מלאה ב-AWS (VPC, Subnet, Security Group, EC2) באמצעות Terraform, עם שימוש במשתנים ו-Data Sources.

### דרישות:

1. ליצור תיקייה `lab3-vars`.
2. להגדיר קובץ `variables.tf` עם המשתנים:
   * `aws_region`
   * `instance_type`
   * `key_name`
3. ליצור קובץ `terraform.tfvars` עם ערכים אמיתיים.
4. בקובץ `provider.tf`:
   * להגדיר `provider` שמשתמש ב-`aws_region`.
   * להוסיף Data Sources ל-AMI ו-Availability Zones.
5. בקובץ `main.tf`:
   * ליצור VPC עם CIDR 10.0.0.0/16.
   * ליצור Internet Gateway.
   * ליצור Subnet ציבורי עם CIDR 10.0.1.0/24.
   * ליצור Route Table עם route לאינטרנט.
   * ליצור Security Group עם rules ל-SSH ו-HTTP.
   * ליצור EC2 Instance עם AMI מ-Data Source.
6. להריץ:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
7. לבדוק ב-AWS Console שהתשתית הוקמה בהצלחה.
8. להריץ:
   ```bash
   terraform destroy
   ```
   כדי למחוק את המשאבים.

---

## 🔍 מה למדנו?

### Data Sources
- **`data "aws_availability_zones"`** - קבלת רשימת Availability Zones זמינות
- **`data "aws_ami"`** - קבלת AMI ID דינמי (תמיד העדכני ביותר)

### משאבים חדשים
- **VPC** - רשת וירטואלית פרטית
- **Subnet** - תת-רשת בתוך VPC
- **Internet Gateway** - גישה לאינטרנט
- **Route Table** - טבלת routing
- **Security Group** - כללי אבטחה

### יתרונות השימוש ב-Data Sources
- **AMI תמיד עדכני** - לא צריך לעדכן ידנית
- **גמישות אזורית** - עובד בכל region
- **אוטומציה** - AWS מספק את המידע העדכני ביותר

---

💡 **טיפ:** אפשר ליצור כמה קבצי tfvars שונים (`dev.tfvars`, `prod.tfvars`) ולהריץ:

```bash
terraform apply -var-file="dev.tfvars"
```

כדי להקים סביבות שונות עם אותו קוד.

---

## 🚀 אתגר נוסף

נסו להוסיף:
1. **EBS Volume** מחובר ל-EC2
2. **Elastic IP** לכתובת קבועה
3. **User Data** להתקנה אוטומטית של Apache
4. **Outputs** להצגת IP ו-DNS של השרת
