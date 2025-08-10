# Лабораторная работа 1: Базовый Ansible playbook

## Цель
Создать простой Ansible playbook для настройки веб-сервера.

## Задачи

### Задача 1: Подготовка окружения
1. Установите Ansible:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# CentOS/RHEL
sudo yum install epel-release
sudo yum install ansible

# macOS
brew install ansible
```

2. Проверьте установку:
```bash
ansible --version
```

### Задача 2: Создание inventory
Создайте файл `inventory/hosts`:

```ini
[webservers]
web1 ansible_host=192.168.1.10
web2 ansible_host=192.168.1.11

[dbservers]
db1 ansible_host=192.168.1.20

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
```

### Задача 3: Создание простого playbook
Создайте файл `playbook.yml`:

```yaml
---
- name: Configure web server
  hosts: webservers
  become: true
  vars:
    http_port: 80
    max_clients: 200

  tasks:
    - name: Update apt cache
      apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start and enable Apache
      service:
        name: apache2
        state: started
        enabled: true

    - name: Create web directory
      file:
        path: /var/www/html
        state: directory
        mode: '0755'

    - name: Create index.html
      copy:
        content: |
          <html>
          <head>
            <title>Welcome to {{ ansible_hostname }}</title>
          </head>
          <body>
            <h1>Hello from {{ ansible_hostname }}!</h1>
            <p>This page was configured by Ansible.</p>
          </body>
          </html>
        dest: /var/www/html/index.html
        mode: '0644'
      notify: restart apache

  handlers:
    - name: restart apache
      service:
        name: apache2
        state: restarted
```

### Задача 4: Тестирование подключения
1. Проверьте подключение к хостам:
```bash
ansible webservers -m ping
```

2. Проверьте синтаксис playbook:
```bash
ansible-playbook --syntax-check playbook.yml
```

### Задача 5: Запуск playbook
1. Запустите playbook в режиме dry-run:
```bash
ansible-playbook --check playbook.yml
```

2. Запустите playbook:
```bash
ansible-playbook playbook.yml
```

3. Проверьте результат:
```bash
ansible webservers -m shell -a "curl -s http://localhost"
```

## Критерии оценки

- [ ] Ansible установлен и настроен
- [ ] Inventory файл создан
- [ ] Playbook создан и синтаксически корректен
- [ ] Подключение к хостам работает
- [ ] Apache установлен и запущен
- [ ] Веб-страница доступна
- [ ] Playbook выполняется без ошибок

## Дополнительные задания

1. Добавьте установку PHP
2. Настройте виртуальные хосты
3. Добавьте SSL сертификат
4. Создайте роль для веб-сервера

## Время выполнения: 30 минут
