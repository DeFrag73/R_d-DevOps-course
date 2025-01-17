# Ansible Homework

# README

Цей проект демонструє використання Ansible для автоматизації налаштування серверів у хмарному середовищі AWS. Проект включає створення ролей для базових налаштувань, налаштування фаєрволу, встановлення та налаштування Nginx та MongoDB, а також використання dynamic inventory для управління інфраструктурою AWS. Також використовується Ansible Vault для шифрування конфіденційних даних.

## Опис завдання та виконання

### 1. Створення ролі "baseline" для базових налаштувань серверів

Роль `baseline` використовується для базових налаштувань серверів. Вона включає:
- Налаштування SSH-ключів для користувача `ubuntu`.
- Встановлення базових пакетів, таких як `vim`, `git`, `mc`, та `ufw`.

**Файл ролі:** `roles/baseline/tasks/main.yml`

```yaml
- name: Ensure SSH keys are configured
  authorized_key:
    user: ubuntu
    key: "{{ ssh_public_key }}"

- name: Install basic packages
  apt:
    name:
      - vim
      - git
      - mc
      - ufw
    state: present
    update_cache: yes
```

### 2. Створення ролі для налаштування фаєрволу

Роль `firewall` налаштовує базові правила фаєрволу за допомогою `ufw`. Вона включає:
- Дозвіл на SSH (порт 22).
- Дозвіл на порти MongoDB (27017 та 27018).
- Дозвіл на HTTP та HTTP Alternate порти (80 та 8080).
- Включення фаєрволу.

**Файл ролі:** `roles/firewall/tasks/main.yml`

```yaml
- name: Allow SSH
  ufw:
    rule: allow
    port: 22
    proto: tcp

- name: Allow MongoDB ports
  ufw:
    rule: allow
    port: "{{ item }}"
    proto: tcp
  loop:
    - 27017
    - 27018

- name: Allow HTTP and HTTP Alternate ports
  ufw:
    rule: allow
    port: "{{ item }}"
    proto: tcp
  loop:
    - 80
    - 8080

- name: Enable UFW
  ufw:
    state: enabled
```

### 3. Створення ролі для налаштування Nginx

Роль `nginx` встановлює та налаштовує Nginx. Вона включає:
- Встановлення Nginx.
- Запуск та включення служби Nginx.

**Файл ролі:** `roles/nginx/tasks/main.yml`

```yaml
- name: Install Nginx
  apt:
    name: nginx
    state: present

- name: Start Nginx
  service:
    name: nginx
    state: started
    enabled: yes
```

### 4. Застосування dynamic inventory для управління інфраструктурою

Для управління інфраструктурою AWS використовується dynamic inventory. Налаштовано два файли інвентаризації:
- `inventory/public_instances.aws_ec2.yml` для публічних інстансів.
- `inventory/private_instances.aws_ec2.yml` для приватних інстансів.

### 5. Використання Ansible Vault для шифрування конфіденційних даних

Для шифрування конфіденційних даних, таких як паролі, використовується Ansible Vault. Зашифрований пароль від mongodb зберігається у файлі `vault.yml`.

### 6. Сконфігуровані playbooks для різних ситуацій

Playbook `site.yml` використовується для застосування ролей до різних груп серверів. Він включає:
- Застосування ролі `baseline` та `firewall` до всіх серверів.
- Застосування ролі `mongodb` до приватних серверів.

**Файл playbook:** `playbooks/site.yml`

```yaml
- hosts: all
  become: yes
  gather_facts: yes
  roles:
    - baseline
    - firewall

- hosts: type_public  
  become: yes
  gather_facts: yes
  roles:
    - nginx

- hosts: type_private  
  become: yes
  gather_facts: yes
  roles:
    - mongodb
```

## Використання

1. **Налаштування SSH-ключа:** Переконайтеся, що у вас є SSH-ключ для підключення до серверів. Ключ зберігається у змінній `ssh_public_key` у файлі `group_vars/all.yml`.

2. **Запуск playbook:** Використовуйте команду `ansible-playbook` для запуску playbook:

   ```bash
   ansible-playbook playbooks/site.yml
   ```

3. **Використання Ansible Vault:** Для редагування зашифрованих даних використовуйте команду:

   ```bash
   ansible-vault edit vault.yml
   ```
### Проблеми під час виконання
- Треба було слідкувати за правильним розташуванням файлів в директооріях
- проблеми з підключенням по ssh до EC2 через bastion
- треба було правильно звертатися по тегам до EC2 щоб їх сконфігурувати 


## Висновок

Цей проект демонструє, як можна використовувати Ansible для автоматизації налаштування серверів у хмарному середовищі AWS. Використання ролей, dynamic inventory та Ansible Vault дозволяє ефективно керувати інфраструктурою та забезпечувати безпеку конфіденційних даних.