הנה כל המדריך ב־Markdown מוכן להעתקה:

````markdown
# 🖥 מדריך ליצירת AWS EC2 Instance בעזרת Terraform

במדריך זה נלמד כיצד ליצור שרת וירטואלי (EC2) ב-AWS בעזרת Terraform.  
השלבים כאן מיועדים למתחילים וכתובים בצורה מפורטת.

---

## 📋 דרישות מוקדמות
לפני שנתחיל, ודאו שיש לכם:
1. **חשבון AWS** פעיל.
2. **Access Key** ו-**Secret Key** של AWS (ניתן לייצר ב-AWS IAM).
3. **התקנת Terraform** על המחשב – [הורדה מכאן](https://developer.hashicorp.com/terraform/downloads).
4. **התקנת AWS CLI** – [הורדה מכאן](https://aws.amazon.com/cli/).
5. **עריכת קובץ Credentials** של AWS:
   ```bash
   aws configure
````

הכניסו את:

* AWS Access Key
* AWS Secret Key
* Region (למשל: `us-east-1`)
* Output format (`json`)

---

## 🛠 שלב 1 – יצירת תיקיית פרויקט

ניצור תיקייה חדשה ונעבוד בתוכה:

```bash
mkdir terraform-ec2
cd terraform-ec2
```

---

## 🛠 שלב 2 – קובץ הגדרות ספק (Provider)

ניצור קובץ בשם `provider.tf`:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

> כאן אנחנו מגדירים לאיזה ענן (AWS) ואיזו אזור (Region) אנחנו עובדים.

---

## 🛠 שלב 3 – קובץ הגדרת השרת (Resource)

ניצור קובץ בשם `main.tf`:

```hcl
resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (דוגמה, תלוי Region)
  instance_type = "t2.micro"              # סוג המכונה (זול לשימוש)

  tags = {
    Name = "MyFirstTerraformServer"
  }
}
```

> שימו לב: ה-AMI (התמונה שממנה השרת מוקם) משתנה בהתאם ל-Region.
> ניתן למצוא AMI ID חדש ע"י חיפוש ב-AWS Console.

---

## 🛠 שלב 4 – אתחול פרויקט Terraform

```bash
terraform init
```

הפקודה תוריד את כל החבילות הדרושות לעבודה עם AWS.

---

## 🛠 שלב 5 – בדיקת תוכנית (Plan)

```bash
terraform plan
```

כאן Terraform יציג **מה הולך להיווצר** לפני ביצוע בפועל.

---

## 🛠 שלב 6 – יצירת השרת בפועל

```bash
terraform apply
```

המערכת תבקש אישור (`yes`). לאחר מספר דקות השרת יהיה מוכן.

---

## 🛠 שלב 7 – בדיקה ב-AWS Console

* התחברו ל-[AWS Console](https://console.aws.amazon.com/ec2/).
* עברו לקטגוריית **EC2**.
* חפשו את השרת עם התג `MyFirstTerraformServer`.

---

## 🛠 שלב 8 – מחיקת השרת (חשוב כדי לא לשלם סתם)

```bash
terraform destroy
```

המערכת תבקש אישור (`yes`) ותמחק את כל המשאבים שהוגדרו בקוד.

---

## 🧠 טיפים לסטודנטים

* תמיד הריצו `terraform plan` לפני `apply` כדי למנוע הפתעות.
* שמרו את קבצי ה-Terraform ב-Git כדי לעקוב אחרי שינויים.
* השתמשו ב-tags כדי לזהות את השרתים שלכם בענן.
* אל תשאירו משאבים פעילים בסוף התרגיל – זה יכול לעלות כסף.

---

🎯 **מטרה:** אחרי התרגיל הזה, אתם יודעים להקים שרת AWS EC2 בעזרת Terraform מאפס.

```

אם תרצה, אני יכול להכין לך גרסת Markdown עם **תרשים זרימה ויזואלי** של כל שלבי העבודה ב-Terraform – זה יכול להיות מעולה לשיעור פתיחה.
```
