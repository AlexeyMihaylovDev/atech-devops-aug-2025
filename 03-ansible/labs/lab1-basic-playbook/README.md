# Lab 1: Basic Ansible Playbook

## Objective
Create a simple Ansible playbook for configuring a web server.

## Tasks

### Task 1: Environment Setup
1. Install Ansible:
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

2. Verify installation:
```bash
ansible --version
```

### Task 2: Creating Inventory
Create file `inventory/hosts`:

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

### Task 3: Creating Simple Playbook
Create file `playbook.yml`:

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

### Task 4: Testing Connection
1. Test connection to hosts:
```bash
ansible webservers -m ping
```

2. Check playbook syntax:
```bash
ansible-playbook --syntax-check playbook.yml
```

### Task 5: Running Playbook
1. Run playbook in dry-run mode:
```bash
ansible-playbook --check playbook.yml
```

2. Run playbook:
```bash
ansible-playbook playbook.yml
```

3. Verify result:
```bash
ansible webservers -m shell -a "curl -s http://localhost"
```

## Evaluation Criteria

- [ ] Ansible installed and configured
- [ ] Inventory file created
- [ ] Playbook created and syntactically correct
- [ ] Connection to hosts working
- [ ] Apache installed and running
- [ ] Web page accessible
- [ ] Playbook executes without errors

## Additional Tasks

1. Add PHP installation
2. Configure virtual hosts
3. Add SSL certificate
4. Create a role for web server

## Time to Complete: 30 minutes
