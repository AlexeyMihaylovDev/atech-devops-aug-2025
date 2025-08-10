# שימוש בתמונת nginx הרשמית כבסיס
FROM nginx:alpine

# העתקת הגדרת nginx מותאמת אישית
COPY nginx.conf /etc/nginx/nginx.conf

# העתקת קבצים סטטיים
COPY index.html /usr/share/nginx/html/

# חשיפת פורט 80
EXPOSE 80

# הפעלת nginx
CMD ["nginx", "-g", "daemon off;"]
