# מודול 3: Ansible IaC

## מטרות למידה

- הבנת מושגי ניהול תצורה
- התקנה והגדרת Ansible
- יצירת playbook'ים
- עבודה עם inventory
- שימוש בתפקידים ומודולים

## חלק תיאורטי (שעה)

### 3.1 מה זה Ansible?

Ansible הוא כלי אוטומציה של IT ש:
- משתמש ב-YAML לתיאור תצורות
- לא דורש סוכנים במכונות יעד
- עובד דרך SSH
- יש לו תחביר פשוט
- תומך באידמפוטנטיות

### 3.2 מושגים בסיסיים

#### Inventory
קובץ או תיקייה המכילה מידע על מארחי יעד:

```ini
[webservers]
web1.example.com
web2.example.com

[dbservers]
db1.example.com
db2.example.com

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

#### Playbook
קובץ YAML המתאר משימות לביצוע:

```yaml
---
- name: Install and configure web server
  hosts: webservers
  become: yes
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
```

#### Task
פעולה נפרדת ב-playbook:

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
```

#### Module
פונקציות מוכנות לביצוע פעולות:
- `apt` - ניהול חבילות
- `service` - ניהול שירותים
- `file` - ניהול קבצים
- `template` - עבודה עם תבניות

### 3.3 מבנה פרויקט Ansible

```
project/
├── inventory/
│   ├── hosts
│   └── group_vars/
├── playbooks/
│   ├── main.yml
│   └── site.yml
├── roles/
│   ├── webserver/
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── templates/
│   │   └── vars/
│   └── database/
└── ansible.cfg
```

### 3.4 סוגי קבצים

#### Playbook
קובץ ראשי עם משימות:

```yaml
---
- name: Configure web server
  hosts: webservers
  become: yes
  vars:
    http_port: 80
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
```

#### Role
רכיב לשימוש חוזר:

```yaml
# roles/webserver/tasks/main.yml
---
- name: Install Apache
  apt:
    name: apache2
    state: present

- name: Start Apache
  service:
    name: apache2
    state: started
    enabled: yes
```

#### Handler
משימה מיוחדת שמתבצעת לפי דרישה:

```yaml
- name: Install Apache
  apt:
    name: apache2
    state: present
  notify: restart apache

handlers:
  - name: restart apache
    service:
      name: apache2
      state: restarted
```

### 3.5 משתנים

#### Global Variables
```yaml
# group_vars/all.yml
http_port: 80
db_host: localhost
```

#### Host Variables
```yaml
# host_vars/web1.yml
http_port: 8080
```

#### Play Variables
```yaml
- name: Configure web server
  hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
```

### 3.6 אופרטורים מותנים

```yaml
- name: Install nginx on Ubuntu
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"

- name: Install nginx on CentOS
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"
```

### 3.7 לולאות

```yaml
- name: Install packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - mysql-server
    - php-fpm
```

### 3.8 תבניות

```yaml
- name: Configure nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
  notify: restart nginx
```

## חלק מעשי

### התקנת Ansible

1. **Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

2. **CentOS/RHEL**:
```bash
sudo yum install epel-release
sudo yum install ansible
```

3. **macOS**:
```bash
brew install ansible
```

4. **pip**:
```bash
pip install ansible
```

### הגדרת SSH

1. צור מפתח SSH:
```bash
ssh-keygen -t rsa -b 4096
```

2. העתק מפתח למכונות יעד:
```bash
ssh-copy-id user@target-host
```

## שיעורי בית

1. התקן Ansible
2. צור קובץ inventory
3. כתוב playbook להתקנת שרת אינטרנט
4. צור תפקיד להגדרת בסיס נתונים
5. הגדר משתנים ותבניות

## קישורים שימושיים

- [תיעוד רשמי של Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [פרקטיקות מומלצות של Ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
