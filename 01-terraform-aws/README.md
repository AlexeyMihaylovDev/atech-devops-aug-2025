# Terraform AWS - מודול 2

ברוכים הבאים למודול Terraform AWS! במודול זה נלמד כיצד ליצור ולנהל תשתית AWS באמצעות Infrastructure as Code.

## 🎯 מטרות הלמידה

לאחר השלמת המודול, תוכלו:
- להבין את עקרונות Infrastructure as Code
- ליצור תשתית AWS עם Terraform
- לעבוד עם מודולים Terraform מתקדמים
- לנהל תשתית production-ready
- ליישם best practices לאבטחה וניהול

## 📚 תוכן המודול

### תיאוריה (שעה)
- **Infrastructure as Code** - עקרונות ויתרונות
- **Terraform Basics** - Providers, Resources, State
- **AWS Services** - VPC, EC2, Security Groups, IAM
- **Best Practices** - Security, Cost Optimization, Maintenance

### מעשי (שעה)
- **יצירת VPC מלא** - Subnets, Route Tables, Internet Gateway
- **EC2 Instances** - עם Security Groups ו-Key Pairs
- **מודולים מתקדמים** - Reusable Infrastructure Components
- **Production Setup** - Multi-AZ, Load Balancers, Monitoring

## 🚀 התחלה מהירה

### דרישות מקדימות
- AWS CLI מותקן ומוגדר
- Terraform 1.0+ מותקן
- AWS Account עם הרשאות מתאימות
- ידע בסיסי ב-AWS Services

### התקנה מהירה
```bash
# עבור לתיקיית הפרויקט
cd 02-terraform-aws

# עבור לדוגמה בסיסית
cd infra/example_use_ec2_module

# אתחל Terraform
terraform init

# תכנן תשתית
terraform plan

# צור תשתית
terraform apply
```

## 📁 מבנה הפרויקט

```
02-terraform-aws/
├── infra/                     # תשתית AWS
│   ├── modules/               # מודולים לשימוש חוזר
│   │   └── ec2-complete/      # מודול EC2 מלא
│   ├── example_use_ec2_module/ # דוגמה בסיסית
│   └── example-prod_ec2_module/ # דוגמה ל-production
├── labs/                       # תרגילים מעשיים
│   └── lab1-basic-infrastructure/ # תרגיל 1: תשתית בסיסית
├── simple-ec2/                 # דוגמה פשוטה ל-EC2
└── README.md                   # תיעוד המודול
```

## 🔧 דוגמאות מעשיות

### 1. דוגמה בסיסית - EC2 Module
```hcl
module "ec2_complete" {
  source = "../modules/ec2-complete"
  
  project_name = "my-webapp"
  ami_id       = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  
  # VPC Configuration
  vpc_cidr = "172.16.0.0/16"
  public_subnet_cidr = "172.16.1.0/24"
  private_subnet_cidr = "172.16.2.0/24"
}
```

### 2. דוגמה ל-Production
```hcl
module "ec2_complete" {
  source = "../modules/ec2-complete"
  
  project_name = "production-app"
  instance_type = "t3.medium"
  
  # Production Settings
  deploy_in_private = true
  enable_monitoring = true
  root_volume_size = 50
  
  # Security
  allowed_ssh_cidr = ["10.0.0.0/8"]
  encrypt_volumes = true
}
```

## 📝 תרגילים מעשיים

### תרגיל 1: תשתית בסיסית
**מטרה**: יצירת VPC עם EC2 instance
**זמן**: 20 דקות
**קובץ**: `labs/lab1-basic-infrastructure/README.md`

**מה תלמדו**:
- יצירת VPC ו-Subnets
- הגדרת Security Groups
- יצירת EC2 Instance
- ניהול State ב-Terraform

## 🎨 מודולים מתקדמים

### EC2 Complete Module
המודול `ec2-complete` מספק תשתית מלאה הכוללת:

#### תשתית רשת
- **VPC** עם CIDR מותאם
- **Public Subnet** עם Internet Gateway
- **Private Subnet** עם NAT Gateway (אופציונלי)
- **Route Tables** עם routing rules
- **Security Groups** עם rules מותאמים

#### שרתים ואחסון
- **EC2 Instance** עם AMI מותאם
- **EBS Volume** עם encryption
- **Elastic IP** (עבור private instances)
- **SSH Key Pair** לניהול גישה

#### אבטחה וניטור
- **Security Groups** עם rules מינימליים
- **CloudWatch Monitoring** (אופציונלי)
- **IAM Roles** עם least privilege
- **VPC Flow Logs** (אופציונלי)

## 🔐 אבטחה

### Security Groups
```hcl
# SSH access - מוגבל ל-CIDR ספציפי
allowed_ssh_cidr = ["10.0.0.0/8", "192.168.1.0/24"]

# HTTP/HTTPS access
allowed_http_cidr = ["0.0.0.0/0"]  # או מוגבל ל-CIDR ספציפי

# Custom rules
custom_security_group_rules = [
  {
    type        = "ingress"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
]
```

### Encryption
- **EBS Volumes**: מוצפנים כברירת מחדל
- **S3 Buckets**: Server-side encryption
- **RDS**: Encryption at rest
- **Secrets**: AWS Secrets Manager

## 💰 אופטימיזציית עלויות

### Instance Types
- **Development**: t3.micro (~$8/חודש)
- **Staging**: t3.small (~$15/חודש)
- **Production**: t3.medium (~$25/חודש)

### Storage Optimization
- **EBS gp3**: יותר זול מ-gp2
- **Instance Store**: חינמי (אבל זמני)
- **S3 Lifecycle**: אוטומטי לזיהוי זול יותר

### Cost Monitoring
```hcl
# CloudWatch Billing Alerts
resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "86400"
  statistic           = "Maximum"
  threshold           = "100"
  alarm_description   = "Billing alarm when charges exceed $100"
}
```

## 📊 ניטור ותחזוקה

### CloudWatch Integration
```hcl
# Enable detailed monitoring
enable_monitoring = true

# Custom metrics
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
}
```

### Logging
- **VPC Flow Logs**: ניטור תעבורת רשת
- **CloudTrail**: ניטור API calls
- **CloudWatch Logs**: application logs
- **S3 Access Logs**: ניטור גישה ל-S3

## 🚨 Troubleshooting

### בעיות נפוצות

1. **State Lock Errors**
   ```bash
   # בדוק state lock
   terraform force-unlock [LOCK_ID]
   
   # או מחק state file (זהיר!)
   rm terraform.tfstate
   ```

2. **Provider Version Conflicts**
   ```hcl
   # הגדר version constraints
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 4.0"
       }
     }
   }
   ```

3. **Resource Dependencies**
   ```hcl
   # השתמש ב-depends_on
   resource "aws_instance" "web" {
     depends_on = [aws_security_group.web]
   }
   ```

### פקודות שימושיות
```bash
# בדוק plan
terraform plan -refresh-only

# Import existing resources
terraform import aws_instance.web i-12345678

# Taint resources for recreation
terraform taint aws_instance.web

# Validate configuration
terraform validate
```

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
name: 'Terraform'
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: hashicorp/setup-terraform@v1
    - run: terraform init
    - run: terraform plan
    - run: terraform apply -auto-approve
```

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Terraform Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform changes?'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
```

## 📚 משאבים נוספים

### תיעוד רשמי
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

### קורסים ווידאו
- [Terraform Tutorial for Beginners](https://www.youtube.com/watch?v=SLB_c_ayRMo)
- [AWS with Terraform](https://www.youtube.com/watch?v=7xngnjfIlK4)

### קהילה
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/terraform)
- [Reddit r/Terraform](https://www.reddit.com/r/Terraform/)

## 🎓 הערכה

### מבחן תיאורטי
- 10 שאלות על Infrastructure as Code
- 10 שאלות על Terraform syntax
- 10 שאלות על AWS services
- ציון עובר: 70%

### משימה מעשית
- יצירת תשתית מלאה עם VPC, EC2, RDS
- שימוש במודולים מותאמים
- הגדרת monitoring ו-alerts
- ניהול state ו-backup

## 🚀 הצעדים הבאים

לאחר השלמת מודול זה:
1. **המשיכו למודול Ansible** - Configuration Management
2. **צרו תשתית משלכם** לפרויקט אמיתי
3. **התנסו ב-advanced features** - Multi-region, Workspaces
4. **שלבו עם CI/CD** - GitHub Actions, Jenkins

---

**בהצלחה בלמידת Terraform! 🚀**

אם יש לכם שאלות או בעיות, אל תהססו לפנות לעזרה.
