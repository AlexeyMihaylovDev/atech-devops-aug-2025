# עבודת מעבדה 1: יצירת pipeline בסיסי

## מטרה
ליצור Jenkins pipeline פשוט שמבצע פעולות בסיסיות של בנייה ובדיקה.

## משימות

### משימה 1: התקנת Jenkins
1. התקן Jenkins באמצעות Docker:
```bash
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

2. פתח דפדפן ועבור ל-`http://localhost:8080`

3. קבל סיסמה ראשונית של מנהל:
```bash
docker exec <container_id> cat /var/lib/jenkins/secrets/initialAdminPassword
```

4. התקן תוספים מומלצים

### משימה 2: יצירת pipeline ראשון
1. צור Pipeline job חדש ב-Jenkins
2. קרא לו `my-first-pipeline`
3. בחלק Pipeline בחר "Pipeline script from SCM"
4. בחר Git כ-SCM
5. ציין URL של המאגר שלך

### משימה 3: יצירת Jenkinsfile
צור קובץ `Jenkinsfile` בשורש המאגר שלך עם התוכן הבא:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World!'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'sleep 3'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'sleep 2'
            }
        }
    }
}
```

### משימה 4: הפעלת pipeline
1. שמור שינויים ב-Git
2. הפעל pipeline ב-Jenkins
3. בדוק שכל השלבים התבצעו בהצלחה

## קריטריונים להערכה

- [ ] Jenkins הותקן והוגדר בהצלחה
- [ ] Pipeline נוצר והוגדר
- [ ] Jenkinsfile נוסף למאגר
- [ ] Pipeline מתבצע ללא שגיאות
- [ ] כל השלבים (Hello, Build, Test) מתבצעים

## משימות נוספות

1. הוסף שלב "Deploy" ב-pipeline
2. הוסף תנאי ש-deploy יתבצע רק עבור ענף main
3. הוסף התראות על ביצוע מוצלח/לא מוצלח

## זמן ביצוע: 30 דקות
