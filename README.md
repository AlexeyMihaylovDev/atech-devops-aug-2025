# קורס הכשרה ב-DevOps

## סקירת הקורס

קורס זה מיועד ללימוד הכלים הבסיסיים של DevOps. הקורס מחולק ל-4 מודולים, כל אחד מהם כולל חלק תיאורטי ועבודות מעבדה מעשיות.

### מבנה הקורס

- **מודול 1: Jenkins CI/CD** - אוטומציה של בנייה ופריסה
- **מודול 2: Terraform AWS IaC** - תשתית כקוד ב-AWS
- **מודול 3: Ansible IaC** - ניהול תצורה ואוטומציה
- **מודול 4: Docker** - מיכלון אפליקציות

### מסגרת זמן

- **תיאוריה**: 4 שעות (שעה לכל מודול)
- **מעשי**: 4 שעות (שעה לכל מודול)
- **זמן כולל**: 8 שעות

### דרישות

- ידע בסיסי ב-Linux
- הבנת מושגי DevOps
- גישה לחשבון AWS (עבור מודול Terraform)
- כלים מותקנים (ראה כל מודול)

### מבנה תיקיות

```
├── 01-jenkins-cicd/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-pipeline/
│   │   │   └── Jenkinsfile
│   │   └── java-maven-pipeline/
│   │       └── Jenkinsfile
│   └── labs/
│       ├── lab1-basic-pipeline/
│       │   └── README.md
│       └── lab2-advanced-pipeline/
│           └── README.md
├── 02-terraform-aws/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-ec2/
│   │   │   └── main.tf
│   │   └── modular-vpc/
│   │       └── variables.tf
│   └── labs/
│       └── lab1-basic-infrastructure/
│           └── README.md
├── 03-ansible/
│   ├── README.md
│   ├── examples/
│   │   ├── simple-playbook/
│   │   │   └── playbook.yml
│   │   └── role-example/
│   │       └── roles/webserver/tasks/main.yml
│   └── labs/
│       └── lab1-basic-playbook/
│           └── README.md
└── 04-docker/
    ├── README.md
    ├── examples/
    │   ├── simple-webapp/
    │   │   ├── Dockerfile
    │   │   └── index.html
    │   └── multi-stage/
    │       └── Dockerfile
    └── labs/
        └── lab1-basic-docker/
            └── README.md
```

### איך להשתמש

1. **התחל בלימוד החומר התיאורטי** ב-`README.md` של כל מודול
2. **בצע דוגמאות מעשיות** בתיקיית `examples/`
3. **השלם עבודות מעבדה** בתיקיית `labs/`

### תוכנית לימודים

#### יום 1: Jenkins CI/CD (2 שעות)
- **תיאוריה (שעה)**: מושגי CI/CD, ארכיטקטורת Jenkins, Pipeline'ים
- **מעשי (שעה)**: התקנת Jenkins, יצירת pipeline'ים, אינטגרציה עם Git

#### יום 2: Terraform AWS IaC (2 שעות)
- **תיאוריה (שעה)**: תשתית כקוד, יסודות Terraform, ספק AWS
- **מעשי (שעה)**: יצירת VPC, מופעי EC2, מודולים

#### יום 3: Ansible IaC (2 שעות)
- **תיאוריה (שעה)**: ניהול תצורה, ארכיטקטורת Ansible, Playbook'ים
- **מעשי (שעה)**: יצירת playbook'ים, תפקידים, inventory

#### יום 4: Docker (2 שעות)
- **תיאוריה (שעה)**: מיכלון, ארכיטקטורת Docker, Dockerfile
- **מעשי (שעה)**: יצירת תמונות, מיכלים, Docker Compose

### הערכה

כל מודול כולל:
- **מבחן תיאורטי** - בדיקת הבנת מושגים
- **משימה מעשית** - ביצוע עבודות מעבדה
- **שיעורי בית** - עבודה עצמאית

### משאבים נוספים

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Documentation](https://docs.docker.com/)

### תמיכה

לשאלות ותמיכה:
- צור issue במאגר
- פנה לתיעוד של כל כלי
- השתמש בפורומים הרשמיים של הקהילה

---

**בהצלחה בלימוד DevOps! 🚀**
