# מודול 2: Terraform AWS IaC

## מטרות למידה

- הבנת מושגי Infrastructure as Code (IaC)
- התקנה והגדרת Terraform
- עבודה עם ספק AWS
- יצירה וניהול תשתית
- פרקטיקות מומלצות של Terraform

## חלק תיאורטי (שעה)

### 2.1 מה זה Infrastructure as Code (IaC)?

**Infrastructure as Code** - גישה לניהול תשתית דרך קוד, ולא דרך פעולות ידניות.

יתרונות:
- גרסה של תשתית
- יכולת שכפול
- אוטומציה
- תיעוד

### 2.2 Terraform - סקירה

Terraform הוא כלי לניהול תשתית מ-HashiCorp:
- תומך במספר ספקים (AWS, Azure, GCP, וכו')
- משתמש בתחביר הצהרתי
- שומר מצב תשתית
- תומך במודולים ושימוש חוזר בקוד

### 2.3 מושגים בסיסיים

#### Provider
ספק הוא תוסף שמתקשר עם ספק ענן:
```hcl
provider "aws" {
  region = "us-west-2"
}
```

#### Resource
משאב הוא אובייקט תשתית:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

#### Data Source
מקור נתונים - לקבלת מידע על משאבים קיימים:
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}
```

#### Variable
משתנים לפרמטריזציה:
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

#### Output
ערכי פלט:
```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### 2.4 מחזור חיים של Terraform

1. **terraform init** - אתחול
2. **terraform plan** - תכנון שינויים
3. **terraform apply** - החלת שינויים
4. **terraform destroy** - מחיקת משאבים

### 2.5 מצב (State)

Terraform שומר מצב תשתית בקובץ או אחסון מרוחק:
- קובץ מקומי (ברירת מחדל)
- S3 bucket
- Terraform Cloud
- Consul

### 2.6 מודולים

מודולים הם רכיבים לשימוש חוזר:
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr = "10.0.0.0/16"
  environment = "production"
}
```

### 2.7 פרקטיקות מומלצות

1. **גרסה**: השתמש ב-Git לגרסה של קוד
2. **מודולים**: חלק קוד למודולים
3. **משתנים**: השתמש במשתנים לפרמטריזציה
4. **Backend**: השתמש באחסון מרוחק למצב
5. **Workspaces**: השתמש ב-workspace'ים לסביבות שונות

## חלק מעשי

### התקנת Terraform

1. **Windows**:
```bash
# הורד מהאתר הרשמי
# https://www.terraform.io/downloads.html
```

2. **Linux**:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

3. **macOS**:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### הגדרת AWS

1. התקן AWS CLI
2. הגדר credentials:
```bash
aws configure
```

3. או השתמש במשתני סביבה:
```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_REGION="us-west-2"
```

## שיעורי בית

1. התקן Terraform ו-AWS CLI
2. צור VPC פשוט עם תת-רשתות
3. פרוס מופע EC2 ב-VPC שנוצר
4. הגדר Security Groups
5. השתמש במודולים לארגון קוד

## קישורים שימושיים

- [תיעוד רשמי של Terraform](https://www.terraform.io/docs)
- [תיעוד ספק AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [פרקטיקות מומלצות של Terraform](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
