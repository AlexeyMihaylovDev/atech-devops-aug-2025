# מודול 4: Docker

## מטרות למידה

- הבנת מושגי מיכלון
- התקנה והגדרת Docker
- יצירת תמונות Docker
- עבודה עם מיכלי Docker
- Docker Compose ואורכיסטרציה

## חלק תיאורטי (שעה)

### 4.1 מה זה Docker?

Docker הוא פלטפורמה לפיתוח, אספקה והפעלת אפליקציות במיכלים:
- **מיכל** - סביבה מבודדת לאפליקציה
- **תמונה** - תבנית ליצירת מיכלים
- **Registry** - מאגר תמונות (Docker Hub, AWS ECR, וכו')

### 4.2 מושגים בסיסיים

#### Container
מיכל הוא תהליך מבודד ש:
- יש לו מערכת קבצים, CPU, זיכרון משלו
- מבודד ממיכלים אחרים
- קל להעברה בין סביבות

#### Image
תמונה היא תבנית שלא ניתנת לשינוי:
- מכילה קוד, runtime, ספריות
- נוצרת מ-Dockerfile
- יכולה להיות עם גרסה

#### Dockerfile
קובץ עם הוראות ליצירת תמונה:

```dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y nginx
COPY index.html /var/www/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 4.3 ארכיטקטורת Docker

```
┌─────────────────┐
│   Docker CLI    │
├─────────────────┤
│  Docker Daemon  │
├─────────────────┤
│   Containers    │
│   ┌─────────┐   │
│   │ App 1   │   │
│   └─────────┘   │
│   ┌─────────┐   │
│   │ App 2   │   │
│   └─────────┘   │
└─────────────────┘
```

### 4.4 פקודות בסיסיות

#### עבודה עם תמונות
```bash
# בניית תמונה
docker build -t myapp:latest .

# צפייה בתמונות
docker images

# מחיקת תמונה
docker rmi myapp:latest
```

#### עבודה עם מיכלים
```bash
# הפעלת מיכל
docker run -d -p 8080:80 myapp:latest

# צפייה במיכלים
docker ps

# עצירת מיכל
docker stop <container_id>

# מחיקת מיכל
docker rm <container_id>
```

### 4.5 הוראות Dockerfile

#### FROM
תמונה בסיסית:
```dockerfile
FROM ubuntu:20.04
FROM node:16-alpine
FROM python:3.9-slim
```

#### RUN
ביצוע פקודות:
```dockerfile
RUN apt-get update && apt-get install -y nginx
RUN npm install
```

#### COPY/ADD
העתקת קבצים:
```dockerfile
COPY app.js /app/
COPY package*.json ./
```

#### WORKDIR
תיקיית עבודה:
```dockerfile
WORKDIR /app
```

#### EXPOSE
פתיחת פורטים:
```dockerfile
EXPOSE 80
EXPOSE 3000
```

#### CMD/ENTRYPOINT
פקודה ברירת מחדל:
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["node", "app.js"]
```

### 4.6 Docker Compose

כלי להגדרה והפעלת אפליקציות מרובות מיכלים:

```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    depends_on:
      - db
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

### 4.7 Volumes ו-Networks

#### Volumes
אחסון נתונים קבוע:
```bash
# יצירת volume
docker volume create mydata

# שימוש ב-volume
docker run -v mydata:/app/data myapp
```

#### Networks
אינטראקציה רשתית בין מיכלים:
```bash
# יצירת רשת
docker network create mynetwork

# חיבור לרשת
docker run --network mynetwork myapp
```

### 4.8 פרקטיקות מומלצות

1. **בנייה רב-שלבית**:
```dockerfile
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

2. **מינימיזציה של גודל**:
- השתמש בתמונות alpine
- מחק קבצים מיותרים
- חבר פקודות RUN

3. **אבטחה**:
- אל תפעיל מיכלים כ-root
- השתמש ב-.dockerignore
- עדכן תמונות בסיס באופן קבוע

## חלק מעשי

### התקנת Docker

1. **Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

2. **CentOS/RHEL**:
```bash
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

3. **macOS**:
```bash
brew install --cask docker
```

### בדיקת התקנה
```bash
docker --version
docker run hello-world
```

## שיעורי בית

1. התקן Docker
2. צור Dockerfile פשוט לאפליקציית אינטרנט
3. בנה והפעל מיכל
4. הגדר Docker Compose לאפליקציה מרובת מיכלים
5. צור volume לאחסון נתונים

## קישורים שימושיים

- [תיעוד רשמי של Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [פרקטיקות מומלצות של Docker](https://docs.docker.com/develop/dev-best-practices/)
