# 🔑 יצירת Key Pair אוטומטית ב-Terraform

## מה השתנה?

עכשיו Terraform יוצר אוטומטית Key Pair עבור ה-EC2 Instance שלך, כך שלא תצטרך ליצור אותו ידנית ב-AWS Console.

## איך זה עובד?

1. **יצירת Private Key**: Terraform יוצר RSA Private Key עם 4096 bits
2. **יצירת Key Pair**: ה-Private Key מועלה ל-AWS כ-Key Pair
3. **שימוש אוטומטי**: ה-EC2 Instance משתמש ב-Key Pair שנוצר

## שלבים לשימוש:

### 1. הרצת Terraform
```bash
terraform init
terraform plan
terraform apply
```

### 2. שמירת Private Key
אחרי ש-Terraform מסיים, הרץ את הסקריפט:
```powershell
.\save_key.ps1
```

### 3. חיבור SSH
```bash
ssh -i demo-keypair.pem ec2-user@<PUBLIC_IP>
```

## פלטים חדשים:

- `private_key` - ה-Private Key (רגיש, לא מוצג ב-logs)
- `key_pair_name` - שם ה-Key Pair שנוצר
- `ssh_command` - פקודת SSH מוכנה

## יתרונות:

✅ **אוטומטי** - לא צריך ליצור Key Pair ידנית  
✅ **בטוח** - Private Key נשמר רק אצלך  
✅ **ייחודי** - כל הרצה יוצרת Key Pair חדש  
✅ **פשוט** - הכל מוכן לשימוש  

## הערות חשובות:

- ה-Private Key נשמר רק ב-output של Terraform
- שמור את הקובץ `demo-keypair.pem` במקום בטוח
- אל תשתף את ה-Private Key עם אף אחד
- אם תמחק את ה-state, תאבד גישה לשרת
