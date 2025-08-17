# Jenkins CI/CD - מודול 1

ברוכים הבאים למודול Jenkins CI/CD! במודול זה נלמד כיצד להקים ולנהל pipelines אוטומטיים לבנייה ופריסה.

## 🎯 מטרות הלמידה

לאחר השלמת המודול, תוכלו:
- להבין את עקרונות CI/CD
- להתקין ולהגדיר Jenkins
- ליצור pipelines בסיסיים ומתקדמים
- לשלב Jenkins עם Git ו-webhooks
- לנהל Jenkins pipelines ביעילות

## 📚 תוכן המודול

### תיאוריה (שעה)
- **מושגי CI/CD** - Continuous Integration/Continuous Deployment
- **ארכיטקטורת Jenkins** - Master/Agent, Plugins
- **Pipeline Syntax** - Declarative vs Scripted
- **Best Practices** - Security, Performance, Maintenance

### מעשי (שעה)
- **התקנת Jenkins** - Docker, Docker Compose
- **יצירת Pipeline'ים** - Simple, Multi-stage, Declarative
- **אינטגרציה עם Git** - Webhooks, SCM Polling
- **ניהול Pipeline'ים** - Monitoring, Troubleshooting

## 🚀 התחלה מהירה

### דרישות מקדימות
- Docker ו-Docker Compose מותקנים
- ידע בסיסי ב-Git
- הבנה בסיסית ב-Linux commands

### התקנה מהירה
```bash
# עבור לתיקיית ההתקנה
cd 01-jenkins-cicd/install

# הפעל Jenkins עם Docker Compose
docker-compose up -d

# פתח בדפדפן
http://localhost:8080
```

## 📁 מבנה הפרויקט

```
01-jenkins-cicd/
├── examples/                  # דוגמאות מעשיות
│   ├── simple-pipeline/      # Pipeline בסיסי
│   └── java-maven-pipeline/  # Pipeline ל-Java Maven
├── install/                   # סקריפטי התקנה
│   ├── Docker-compose.yaml   # הגדרת Jenkins עם Docker
│   └── script.sh             # סקריפט התקנה אוטומטי
├── labs/                      # תרגילים מעשיים
│   ├── lab1-basic-pipeline/  # תרגיל 1: Pipeline בסיסי
│   └── lab2-advanced-pipeline/ # תרגיל 2: Pipeline מתקדם
├── pipelines/                 # תבניות pipelines
│   ├── React/                 # Pipeline ל-React app
│   ├── React_CI_CD/          # Pipeline CI/CD מלא
│   └── sonar_scan/           # Pipeline עם SonarQube
└── README.md                  # תיעוד המודול
```

## 🔧 דוגמאות מעשיות

### 1. Simple Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### 2. Java Maven Pipeline
```groovy
pipeline {
    agent any
    tools {
        maven 'Maven 3.8.1'
        jdk 'JDK 11'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
    }
}
```

## 📝 תרגילים מעשיים

### תרגיל 1: Pipeline בסיסי
**מטרה**: יצירת pipeline פשוט עם שלושה שלבים
**זמן**: 15 דקות
**קובץ**: `labs/lab1-basic-pipeline/README.md`

### תרגיל 2: Pipeline מתקדם
**מטרה**: יצירת pipeline עם תנאים ושלבים מותאמים
**זמן**: 30 דקות
**קובץ**: `labs/lab2-advanced-pipeline/README.md`

## 🎨 תבניות Pipelines

### React Application
- **Build.groovy** - בנייה ובדיקות
- **Deploy.groovy** - פריסה ל-production

### React CI/CD
- **helm-chart-runner.groovy** - פריסה עם Helm

### SonarQube Integration
- **Build.groovy** - בנייה עם ניתוח איכות קוד

## 🔐 אבטחה

### הגדרות אבטחה חשובות
- **Authentication** - LDAP, OAuth, SAML
- **Authorization** - Role-based access control
- **Network Security** - Firewall rules, VPN
- **Plugin Security** - רק plugins מאושרים

### Best Practices
- השתמש ב-Service Accounts
- הגבל גישה לפי IP
- עדכן Jenkins באופן קבוע
- גבה configurations

## 📊 ניטור ותחזוקה

### CloudWatch Integration
- **Metrics**: Build success rate, Duration, Queue length
- **Logs**: Pipeline execution logs
- **Alerts**: Build failures, Performance issues

### תחזוקה שוטפת
- **Disk Space**: ניקוי builds ישנים
- **Memory**: הגדרת heap size
- **Plugins**: עדכון והסרת plugins לא בשימוש
- **Backup**: גיבוי configurations ו-data

## 🚨 Troubleshooting

### בעיות נפוצות

1. **Jenkins לא עולה**
   ```bash
   # בדוק logs
   docker-compose logs jenkins
   
   # בדוק ports
   netstat -tulpn | grep 8080
   ```

2. **Pipeline נכשל**
   - בדוק syntax של Jenkinsfile
   - בדוק permissions לקבצים
   - בדוק network connectivity

3. **Builds תלויים**
   - בדוק agent availability
   - בדוק resource constraints
   - בדוק plugin conflicts

### פקודות שימושיות
```bash
# בדוק status של Jenkins
curl -s http://localhost:8080/api/json

# בדוק builds
curl -s http://localhost:8080/job/[JOB_NAME]/api/json

# בדוק queue
curl -s http://localhost:8080/queue/api/json
```

## 💰 עלויות

### Jenkins Self-Hosted
- **Server**: EC2 t3.medium (~$25/חודש)
- **Storage**: EBS 50GB (~$5/חודש)
- **Total**: ~$30/חודש

### Jenkins Cloud
- **Jenkins X**: Free tier available
- **AWS CodePipeline**: Pay per use
- **GitHub Actions**: Free for public repos

## 📚 משאבים נוספים

### תיעוד רשמי
- [Jenkins User Guide](https://www.jenkins.io/doc/book/)
- [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Best Practices](https://www.jenkins.io/doc/book/pipeline/best-practices/)

### קורסים ווידאו
- [Jenkins Tutorial for Beginners](https://www.youtube.com/watch?v=LFDrDnKOTtY)
- [Jenkins Pipeline Tutorial](https://www.youtube.com/watch?v=7KTSa7bDNcI)

### קהילה
- [Jenkins Community](https://community.jenkins.io/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/jenkins)
- [Reddit r/jenkins](https://www.reddit.com/r/jenkins/)

## 🎓 הערכה

### מבחן תיאורטי
- 10 שאלות על מושגי CI/CD
- 10 שאלות על Jenkins architecture
- ציון עובר: 70%

### משימה מעשית
- יצירת pipeline מורכב
- אינטגרציה עם Git repository
- ניתוח איכות קוד עם SonarQube

## 🚀 הצעדים הבאים

לאחר השלמת מודול זה:
1. **המשיכו למודול Terraform** - Infrastructure as Code
2. **צרו pipeline משלכם** לפרויקט אמיתי
3. **התנסו ב-advanced features** - Multi-branch, Parallel execution
4. **שלבו עם כלי DevOps נוספים** - SonarQube, Nexus, Artifactory

---

**בהצלחה בלמידת Jenkins! 🚀**

אם יש לכם שאלות או בעיות, אל תהססו לפנות לעזרה.
