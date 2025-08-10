# Модуль 3: Ansible IaC

## Цели обучения

- Понимание концепций конфигурационного управления
- Установка и настройка Ansible
- Создание playbook'ов
- Работа с inventory
- Использование ролей и модулей

## Теоретическая часть (1 час)

### 3.1 Что такое Ansible?

Ansible - это инструмент автоматизации IT, который:
- Использует YAML для описания конфигураций
- Не требует агентов на целевых машинах
- Работает по SSH
- Имеет простой синтаксис
- Поддерживает идемпотентность

### 3.2 Основные концепции

#### Inventory
Файл или директория, содержащая информацию о целевых хостах:

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
YAML файл, описывающий задачи для выполнения:

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
Отдельная операция в playbook:

```yaml
- name: Install nginx
  apt:
    name: nginx
    state: present
```

#### Module
Готовые функции для выполнения операций:
- `apt` - управление пакетами
- `service` - управление сервисами
- `file` - управление файлами
- `template` - работа с шаблонами

### 3.3 Структура Ansible проекта

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

### 3.4 Типы файлов

#### Playbook
Основной файл с задачами:

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
Переиспользуемый компонент:

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
Специальная задача, выполняемая по требованию:

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

### 3.5 Переменные

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

### 3.6 Условные операторы

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

### 3.7 Циклы

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

### 3.8 Шаблоны

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

## Практическая часть

### Установка Ansible

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

### Настройка SSH

1. Генерируйте SSH ключ:
```bash
ssh-keygen -t rsa -b 4096
```

2. Скопируйте ключ на целевые машины:
```bash
ssh-copy-id user@target-host
```

## Домашнее задание

1. Установите Ansible
2. Создайте inventory файл
3. Напишите playbook для установки веб-сервера
4. Создайте роль для настройки базы данных
5. Настройте переменные и шаблоны

## Полезные ссылки

- [Официальная документация Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
