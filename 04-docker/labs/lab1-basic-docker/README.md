# עבודת מעבדה 1: Docker בסיסי

## מטרה
יצירת מיכל Docker פשוט עם אפליקציית ווב.

## משימות

### משימה 1: הכנת הסביבה
1. התקנת Docker:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# CentOS/RHEL
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# macOS
brew install --cask docker
```

2. בדיקת ההתקנה:
```bash
docker --version
docker run hello-world
```

### משימה 2: יצירת אפליקציית ווב פשוטה
1. יצירת תיקיית הפרויקט:
```bash
mkdir docker-webapp
cd docker-webapp
```

2. יצירת קובץ `index.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Docker Web App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 ברוכים הבאים ל-Docker!</h1>
        <p>זוהי אפליקציית ווב פשוטה שרצה במיכל Docker.</p>
        <p>השעה הנוכחית: <span id="time"></span></p>
    </div>
    <script>
        document.getElementById('time').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
```

### משימה 3: יצירת Dockerfile
יצירת קובץ `Dockerfile`:

```dockerfile
# שימוש בתמונת nginx הרשמית כבסיס
FROM nginx:alpine

# העתקת קובץ ה-HTML לתיקיית ברירת המחדל של nginx
COPY index.html /usr/share/nginx/html/

# חשיפת פורט 80
EXPOSE 80

# הפעלת nginx
CMD ["nginx", "-g", "daemon off;"]
```

### משימה 4: בנייה והפעלת המיכל
1. בניית התמונה:
```bash
docker build -t my-webapp .
```

2. בדיקה שהתמונה נוצרה:
```bash
docker images
```

3. הפעלת המיכל:
```bash
docker run -d -p 8080:80 --name webapp my-webapp
```

4. בדיקה שהמיכל פועל:
```bash
docker ps
```

5. פתיחת הדפדפן וניווט ל-`http://localhost:8080`

### משימה 5: עבודה עם המיכל
1. צפייה בלוגים של המיכל:
```bash
docker logs webapp
```

2. כניסה למיכל:
```bash
docker exec -it webapp sh
```

3. עצירת המיכל:
```bash
docker stop webapp
```

4. מחיקת המיכל:
```bash
docker rm webapp
```

5. מחיקת התמונה:
```bash
docker rmi my-webapp
```

## קריטריוני הערכה

- [ ] Docker מותקן ומוגדר
- [ ] אפליקציית הווב נוצרה
- [ ] Dockerfile נוצר
- [ ] התמונה נבנתה בהצלחה
- [ ] המיכל פועל ונגיש
- [ ] דף הווב מוצג כראוי
- [ ] המיכל נעצר ונמחק

## משימות נוספות

1. הוספת הגדרת nginx מותאמת אישית
2. יצירת volume לאחסון נתונים
3. הגדרת משתני סביבה
4. יצירת קובץ .dockerignore

## זמן ביצוע: 30 דקות
