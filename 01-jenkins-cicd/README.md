# מודול 1: Jenkins CI/CD

## מטרות למידה

- הבנת מושגי CI/CD
- התקנה והגדרת Jenkins
- יצירת pipeline'ים
- אינטגרציה עם Git
- אוטומציה של בנייה ופריסה

## חלק תיאורטי (שעה)

### 1.1 מה זה CI/CD?

**Continuous Integration (CI)** - פרקטיקה של בנייה ובדיקה אוטומטית של קוד בכל commit.

**Continuous Deployment (CD)** - פריסה אוטומטית של אפליקציה לפרודקשן לאחר בדיקות מוצלחות.

### 1.2 Jenkins - סקירה

Jenkins הוא שרת אוטומציה open-source שתומך ב:
- בניית פרויקטים
- בדיקה
- פריסה
- ניטור

### 1.3 מושגים בסיסיים

#### Pipeline
רצף שלבים שמתבצעים אוטומטית:
1. **Build** - בניית האפליקציה
2. **Test** - הרצת בדיקות
3. **Deploy** - פריסה

#### Job
משימה שמתבצעת על ידי Jenkins. יכולה להיות:
- Freestyle project
- Pipeline project
- Multi-configuration project

#### Node
שרת או סוכן שעליו מתבצעות משימות.

### 1.4 Jenkinsfile

Jenkinsfile הוא קובץ שמתאר pipeline בקוד:

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

### 1.5 סוגי pipeline'ים

#### Declarative Pipeline
תחביר מודרני, קריא יותר:

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

#### Scripted Pipeline
תחביר קלאסי ב-Groovy:

```groovy
node {
    stage('Build') {
        sh 'mvn clean package'
    }
}
```

### 1.6 אינטגרציה עם Git

Jenkins יכול:
- לעקוב אחר שינויים במאגר
- להפעיל בנייה ב-push
- לעבוד עם pull requests
- לתמוך ב-webhook'ים

### 1.7 תוספים

תוספים פופולריים:
- **Git** - אינטגרציה עם Git
- **Docker** - עבודה עם מיכלים
- **Pipeline** - תמיכה ב-pipeline'ים
- **Credentials** - ניהול סודות

## חלק מעשי

### התקנת Jenkins

1. **Docker** (מומלץ):
```bash
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

2. **Ubuntu/Debian**:
```bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

### הגדרה ראשונית

1. פתח `http://localhost:8080`
2. קבל סיסמה ראשונית של מנהל:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. התקן תוספים מומלצים
4. צור משתמש מנהל

## שיעורי בית

1. התקן Jenkins מקומית
2. צור pipeline פשוט לבניית אפליקציית Java
3. הגדר אינטגרציה עם מאגר Git
4. הוסף שלב בדיקה

## קישורים שימושיים

- [תיעוד רשמי של Jenkins](https://www.jenkins.io/doc/)
- [תחביר Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [תוספי Jenkins](https://plugins.jenkins.io/)
