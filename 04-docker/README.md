# Docker - מודול 4

ברוכים הבאים למודול Docker! במודול זה נלמד כיצד ליצור ולהריץ containers, לבנות Docker images ולנהל containerized applications.

## 🎯 מטרות הלמידה

לאחר השלמת המודול, תוכלו:
- להבין את עקרונות Containerization
- ליצור ולנהל Docker containers
- לבנות Docker images עם Dockerfile
- לעבוד עם Docker Compose
- ליישם best practices לאבטחה וניהול

## 📚 תוכן המודול

### תיאוריה (שעה)
- **Containerization** - עקרונות ויתרונות
- **Docker Architecture** - Docker Engine, Images, Containers
- **Dockerfile** - Layers, Multi-stage builds, Best practices
- **Container Orchestration** - Docker Compose, Docker Swarm

### מעשי (שעה)
- **יצירת Containers** - Basic commands, Image management
- **בניית Images** - Dockerfile, Multi-stage builds
- **עבודה עם Docker Compose** - Multi-container applications
- **Container Management** - Networking, Volumes, Logs

## 🚀 התחלה מהירה

### דרישות מקדימות
- Linux, macOS או Windows 10+ עם WSL2
- 4GB RAM לפחות
- 20GB disk space
- ידע בסיסי ב-command line

### התקנה מהירה
```bash
# Linux (Ubuntu/Debian)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# macOS
brew install --cask docker

# Windows
# הורד Docker Desktop מהאתר הרשמי

# בדוק התקנה
docker --version
docker run hello-world
```

## 📁 מבנה הפרויקט

```
04-docker/
├── examples/                   # דוגמאות מעשיות
│   ├── simple-webapp/         # אפליקציית web פשוטה
│   │   ├── Dockerfile         # הגדרת image
│   │   └── index.html         # קובץ HTML
│   └── multi-stage/           # Multi-stage build
│       └── Dockerfile         # Dockerfile מתקדם
├── labs/                       # תרגילים מעשיים
│   └── lab1-basic-docker/     # תרגיל 1: Docker בסיסי
└── README.md                   # תיעוד המודול
```

## 🔧 דוגמאות מעשיות

### 1. Simple Web App
```dockerfile
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Docker Demo</title>
</head>
<body>
    <h1>Hello from Docker!</h1>
    <p>This is a simple web application running in a container.</p>
</body>
</html>
```

### 2. Multi-stage Build
```dockerfile
# Multi-stage Dockerfile
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 3. Docker Compose
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    volumes:
      - ./logs:/var/log/nginx
    depends_on:
      - db
      
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## 📝 תרגילים מעשיים

### תרגיל 1: Docker בסיסי
**מטרה**: יצירת container פשוט עם web application
**זמן**: 20 דקות
**קובץ**: `labs/lab1-basic-docker/README.md`

**מה תלמדו**:
- יצירת Dockerfile בסיסי
- בניית Docker image
- הרצת container
- ניהול images ו-containers

## 🎨 Docker Images

### Image Layers
```
Base Image (Ubuntu 20.04)
    ↓
Install Dependencies
    ↓
Copy Application Code
    ↓
Set Environment Variables
    ↓
Expose Ports
    ↓
Define Entry Point
```

### Best Practices
```dockerfile
# Use specific base image versions
FROM ubuntu:20.04

# Set working directory
WORKDIR /app

# Copy requirements first (for better caching)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application code
COPY . .

# Use non-root user
RUN useradd -m myuser
USER myuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1
```

## 🔐 אבטחה

### Security Best Practices
```dockerfile
# Use minimal base images
FROM alpine:3.14

# Don't run as root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

# Scan for vulnerabilities
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
#   aquasec/trivy image your-image:tag
```

### Image Scanning
```bash
# Trivy vulnerability scanner
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image your-image:tag

# Docker Scout
docker scout cves your-image:tag
```

## 📊 ניטור ותחזוקה

### Container Monitoring
```bash
# Resource usage
docker stats

# Container logs
docker logs container_name

# Container inspection
docker inspect container_name
```

### Health Checks
```dockerfile
# Health check in Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

### Logging
```yaml
# docker-compose.yml with logging
services:
  web:
    image: nginx
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 🚨 Troubleshooting

### בעיות נפוצות

1. **Container לא עולה**
   ```bash
   # בדוק logs
   docker logs container_name
   
   # בדוק container status
   docker ps -a
   
   # הרץ container interactively
   docker run -it image_name /bin/bash
   ```

2. **Port conflicts**
   ```bash
   # בדוק ports בשימוש
   netstat -tulpn | grep :8080
   
   # שנה port mapping
   docker run -p 8081:80 image_name
   ```

3. **Volume issues**
   ```bash
   # בדוק volumes
   docker volume ls
   
   # בדוק volume contents
   docker run -v volume_name:/data alpine ls /data
   ```

### פקודות שימושיות
```bash
# Clean up unused resources
docker system prune -a

# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Check disk usage
docker system df
```

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
name: 'Docker Build'
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build Docker image
      run: docker build -t myapp .
    - name: Run tests
      run: docker run myapp npm test
    - name: Push to registry
      run: |
        echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
        docker push myapp:latest
```

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run myapp npm test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker push myapp:latest'
            }
        }
    }
}
```

## 💰 אופטימיזציית עלויות

### Image Size Optimization
```dockerfile
# Multi-stage build
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Registry Optimization
- **Use private registries** for internal images
- **Implement image retention policies**
- **Use multi-arch images** for different platforms
- **Implement image scanning** to prevent security issues

## 📚 משאבים נוספים

### תיעוד רשמי
- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### קורסים ווידאו
- [Docker Tutorial for Beginners](https://www.youtube.com/watch?v=3c-iBn73DI4)
- [Docker Complete Course](https://www.youtube.com/watch?v=3c-iBn73DI4)

### קהילה
- [Docker Community](https://www.docker.com/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/docker)
- [Reddit r/docker](https://www.reddit.com/r/docker/)

## 🎓 הערכה

### מבחן תיאורטי
- 10 שאלות על Containerization
- 10 שאלות על Docker architecture
- 10 שאלות על Dockerfile syntax
- ציון עובר: 70%

### משימה מעשית
- יצירת multi-container application
- בניית Docker image עם multi-stage build
- הגדרת Docker Compose עם volumes ו-networks
- ניהול container lifecycle

## 🚀 הצעדים הבאים

לאחר השלמת מודול זה:
1. **השלימו את כל המודולים** - Jenkins, Terraform, Ansible, Docker
2. **צרו פרויקט DevOps מלא** - CI/CD pipeline עם containers
3. **התנסו ב-advanced features** - Docker Swarm, Kubernetes
4. **שלבו עם cloud platforms** - AWS ECS, Azure Container Instances

## 🔗 אינטגרציה עם מודולים אחרים

### Jenkins + Docker
```groovy
pipeline {
    agent any
    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run myapp npm test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker push myapp:latest'
            }
        }
    }
}
```

### Terraform + Docker
```hcl
# ECS Cluster עם Docker
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "my-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512
  
  container_definitions = jsonencode([
    {
      name  = "my-app"
      image = "myapp:latest"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}
```

### Ansible + Docker
```yaml
---
- name: Manage Docker containers
  hosts: docker_hosts
  tasks:
    - name: Install Docker
      package:
        name: docker
        state: present
        
    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes
        
    - name: Pull Docker image
      docker_image:
        name: nginx:latest
        source: pull
        
    - name: Run Docker container
      docker_container:
        name: web
        image: nginx:latest
        state: started
        ports:
          - "80:80"
```

---

**בהצלחה בלמידת Docker! 🚀**

אם יש לכם שאלות או בעיות, אל תהססו לפנות לעזרה.
