# עבודת מעבדה 2: pipeline מתקדם

## מטרה
ליצור Jenkins pipeline מורכב יותר עם אינטגרציית Git, לוגיקה מותנית והתראות.

## משימות

### משימה 1: הגדרת אינטגרציית Git
1. ודא שיש לך מאגר Git עם קוד
2. הגדר webhook במאגר Git שלך (GitHub/GitLab)
3. הגדר Jenkins לעבודה עם webhook'ים

### משימה 2: יצירת Jenkinsfile מתקדם
צור `Jenkinsfile` עם היכולות הבאות:

```groovy
pipeline {
    agent any
    
    environment {
        APP_NAME = 'my-application'
        VERSION = '1.0.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'echo "Building ${APP_NAME} version ${VERSION}"'
                sh 'sleep 5'
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        echo 'Running unit tests...'
                        sh 'sleep 3'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        echo 'Running integration tests...'
                        sh 'sleep 4'
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to staging...'
                sh 'echo "Deploying to staging environment"'
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                echo 'Deploying to production...'
                sh 'echo "Deploying to production environment"'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

### משימה 3: הגדרת התראות
1. התקן תוסף Email Extension Plugin
2. הגדר שרת SMTP ב-Jenkins
3. הוסף התראות email ב-pipeline

### משימה 4: עבודה עם ארטיפקטים
1. הוסף שלב לארכוב ארטיפקטים
2. הגדר פרסום ארטיפקטים

## קריטריונים להערכה

- [ ] אינטגרציית Git הוגדרה
- [ ] Pipeline מתבצע ב-push למאגר
- [ ] ביצוע מקביל של בדיקות עובד
- [ ] לוגיקה מותנית (when) עובדת כראוי
- [ ] התראות נשלחות
- [ ] ארטיפקטים נשמרים

## משימות נוספות

1. הוסף אינטגרציה עם SonarQube לניתוח קוד
2. הגדר אינטגרציה עם Docker ליצירת תמונות
3. הוסף שלב לשליחת התראות ל-Slack

## זמן ביצוע: 45 דקות
