# Ansible - מודול 3

ברוכים הבאים למודול Ansible! במודול זה נלמד כיצד לנהל תצורת שרתים באופן אוטומטי ולבצע אוטומציה של משימות IT.

## 🎯 מטרות הלמידה

לאחר השלמת המודול, תוכלו:
- להבין את עקרונות Configuration Management
- ליצור ולנהל Ansible Playbooks
- לעבוד עם Ansible Roles ו-Collections
- לבצע אוטומציה של משימות IT מורכבות
- ליישם best practices לאבטחה וניהול

## 📚 תוכן המודול

### תיאוריה (שעה)
- **Configuration Management** - עקרונות ויתרונות
- **Ansible Architecture** - Control Node, Managed Nodes, Inventory
- **Playbook Syntax** - Tasks, Handlers, Variables, Templates
- **Best Practices** - Security, Performance, Maintenance

### מעשי (שעה)
- **יצירת Playbooks** - Basic, Advanced, Conditional
- **עבודה עם Roles** - Structure, Dependencies, Reusability
- **ניהול Inventory** - Static, Dynamic, Groups
- **אינטגרציה עם Cloud** - AWS, Azure, GCP

## 🚀 התחלה מהירה

### דרישות מקדימות
- Python 3.6+ מותקן
- Linux או macOS (Windows עם WSL)
- SSH access לשרתים מרוחקים
- ידע בסיסי ב-YAML

### התקנה מהירה
```bash
# התקן Ansible
pip install ansible

# או עם package manager
# Ubuntu/Debian
sudo apt install ansible

# CentOS/RHEL
sudo yum install ansible

# macOS
brew install ansible

# בדוק התקנה
ansible --version
```

## 📁 מבנה הפרויקט

```
03-ansible/
├── examples/                   # דוגמאות מעשיות
│   ├── simple-playbook/       # Playbook בסיסי
│   └── role-example/          # דוגמה ל-Role
│       └── roles/
│           └── webserver/      # Role לשרת web
│               └── tasks/
│                   └── main.yml
├── hosts.ini                   # Inventory file
├── install_ansible             # סקריפט התקנה
├── labs/                       # תרגילים מעשיים
│   └── lab1-basic-playbook/   # תרגיל 1: Playbook בסיסי
├── playbooks/                  # Playbooks מוכנים
│   ├── ping.yaml              # בדיקת חיבור
│   ├── facts.yaml             # איסוף מידע
│   ├── create_dir.yaml        # יצירת תיקיות
│   └── docker_build.yaml      # בניית Docker images
└── README.md                   # תיעוד המודול
```

## 🔧 דוגמאות מעשיות

### 1. Playbook בסיסי
```yaml
---
- name: Basic Playbook Example
  hosts: webservers
  become: yes
  
  tasks:
    - name: Update package cache
      apt:
        update_cache: yes
      
    - name: Install Apache
      apt:
        name: apache2
        state: present
        
    - name: Start and enable Apache
      service:
        name: apache2
        state: started
        enabled: yes
```

### 2. Playbook עם Variables
```yaml
---
- name: Web Server Setup
  hosts: webservers
  vars:
    web_port: 80
    web_root: /var/www/html
    
  tasks:
    - name: Create web directory
      file:
        path: "{{ web_root }}"
        state: directory
        mode: '0755'
        
    - name: Configure Apache port
      lineinfile:
        path: /etc/apache2/ports.conf
        regexp: '^Listen '
        line: 'Listen {{ web_port }}'
```

### 3. Role Example
```yaml
# roles/webserver/tasks/main.yml
---
- name: Install Apache
  package:
    name: apache2
    state: present
    
- name: Configure Apache
  template:
    src: apache2.conf.j2
    dest: /etc/apache2/apache2.conf
    backup: yes
    
- name: Start Apache
  service:
    name: apache2
    state: started
    enabled: yes
```

## 📝 תרגילים מעשיים

### תרגיל 1: Playbook בסיסי
**מטרה**: יצירת playbook לניהול שרת web
**זמן**: 20 דקות
**קובץ**: `labs/lab1-basic-playbook/README.md`

**מה תלמדו**:
- כתיבת playbook בסיסי
- שימוש ב-tasks ו-handlers
- ניהול services ו-packages
- עבודה עם variables

## 🎨 Ansible Roles

### מבנה Role
```
roles/
├── webserver/
│   ├── defaults/
│   │   └── main.yml          # ערכי ברירת מחדל
│   ├── files/                 # קבצים סטטיים
│   ├── handlers/
│   │   └── main.yml          # handlers
│   ├── meta/
│   │   └── main.yml          # metadata ו-dependencies
│   ├── tasks/
│   │   └── main.yml          # tasks עיקריים
│   ├── templates/             # templates עם variables
│   └── vars/
│       └── main.yml          # variables
```

### יצירת Role
```bash
# צור role חדש
ansible-galaxy init my_role

# או צור ידנית
mkdir -p roles/my_role/{tasks,handlers,templates,files,vars,defaults,meta}
```

## 🔐 אבטחה

### SSH Key Management
```bash
# צור SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_key

# העתק public key לשרתים
ssh-copy-id -i ~/.ssh/ansible_key.pub user@server

# הגדר ב-Ansible
# ansible.cfg
[defaults]
private_key_file = ~/.ssh/ansible_key
```

### Vault Encryption
```bash
# צור encrypted file
ansible-vault create secret.yml

# ערוך encrypted file
ansible-vault edit secret.yml

# הרץ playbook עם vault
ansible-playbook playbook.yml --ask-vault-pass
```

### Best Practices
- השתמש ב-SSH keys במקום passwords
- הגבל sudo access לפי commands ספציפיים
- השתמש ב-Ansible Vault למידע רגיש
- הגבל access לפי IP addresses

## 📊 ניטור ותחזוקה

### Ansible Facts
```yaml
- name: Gather system facts
  setup:
  
- name: Display system info
  debug:
    msg: "System: {{ ansible_distribution }} {{ ansible_distribution_version }}"
```

### Logging
```yaml
# ansible.cfg
[defaults]
log_path = /var/log/ansible.log
callback_whitelist = profile_tasks
```

### Performance Optimization
```yaml
# ansible.cfg
[defaults]
forks = 20
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
```

## 🚨 Troubleshooting

### בעיות נפוצות

1. **SSH Connection Issues**
   ```bash
   # בדוק connectivity
   ansible all -m ping
   
   # בדוק SSH configuration
   ssh -vvv user@server
   ```

2. **Permission Denied**
   ```yaml
   # השתמש ב-become
   - name: Install package
     package:
       name: nginx
     become: yes
     become_user: root
   ```

3. **Variable Issues**
   ```yaml
   # בדוק variables
   - name: Debug variables
     debug:
       var: hostvars[inventory_hostname]
   ```

### פקודות שימושיות
```bash
# בדוק syntax
ansible-playbook --syntax-check playbook.yml

# Dry run
ansible-playbook --check playbook.yml

# Verbose output
ansible-playbook -v playbook.yml

# Limit hosts
ansible-playbook playbook.yml --limit webservers
```

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
name: 'Ansible'
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  ansible:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.9'
    - name: Install Ansible
      run: pip install ansible
    - name: Run Ansible Playbook
      run: ansible-playbook playbook.yml --check
```

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Ansible Check') {
            steps {
                sh 'ansible-playbook playbook.yml --check'
            }
        }
        stage('Ansible Deploy') {
            steps {
                input message: 'Deploy with Ansible?'
                sh 'ansible-playbook playbook.yml'
            }
        }
    }
}
```

## 💰 אופטימיזציית עלויות

### Resource Management
- **Parallel Execution**: השתמש ב-forks לניצול משאבים
- **Fact Caching**: שמור facts לזמן מהיר יותר
- **Conditional Tasks**: הרץ tasks רק כשצריך
- **Smart Gathering**: אסוף facts רק כשצריך

### Cloud Integration
```yaml
# Dynamic inventory עם AWS
- name: Configure AWS
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Get EC2 instances
      ec2_instance_info:
        region: us-east-1
      register: ec2_instances
```

## 📚 משאבים נוספים

### תיעוד רשמי
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

### קורסים ווידאו
- [Ansible Tutorial for Beginners](https://www.youtube.com/watch?v=5hycyr-8EKs)
- [Ansible for DevOps](https://www.youtube.com/watch?v=5hycyr-8EKs)

### קהילה
- [Ansible Community](https://www.ansible.com/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/ansible)
- [Reddit r/ansible](https://www.reddit.com/r/ansible/)

## 🎓 הערכה

### מבחן תיאורטי
- 10 שאלות על Configuration Management
- 10 שאלות על Ansible syntax
- 10 שאלות על best practices
- ציון עובר: 70%

### משימה מעשית
- יצירת role מלא לשרת web
- ניהול multiple servers
- שימוש ב-templates ו-variables
- אינטגרציה עם cloud services

## 🚀 הצעדים הבאים

לאחר השלמת מודול זה:
1. **המשיכו למודול Docker** - Containerization
2. **צרו playbooks משלכם** לפרויקט אמיתי
3. **התנסו ב-advanced features** - Collections, Custom Modules
4. **שלבו עם CI/CD** - GitHub Actions, Jenkins

---

**בהצלחה בלמידת Ansible! 🚀**

אם יש לכם שאלות או בעיות, אל תהססו לפנות לעזרה.
