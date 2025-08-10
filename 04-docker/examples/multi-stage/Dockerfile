# Dockerfile רב-שלבי עבור אפליקציית Node.js

# שלב בנייה
FROM node:16-alpine AS builder

WORKDIR /app

# העתקת קבצי package
COPY package*.json ./

# התקנת תלויות
RUN npm ci --only=production

# העתקת קוד המקור
COPY . .

# בניית האפליקציה
RUN npm run build

# שלב ייצור
FROM nginx:alpine

# העתקת קבצים שנבנו משלב הבנייה
COPY --from=builder /app/dist /usr/share/nginx/html

# העתקת הגדרת nginx
COPY nginx.conf /etc/nginx/nginx.conf

# חשיפת פורט 80
EXPOSE 80

# הפעלת nginx
CMD ["nginx", "-g", "daemon off;"]
