# Homework 02: VirtualBox та Vagrant

## Зміст

- [Частина 1: VirtualBox](#частина-1-virtualbox)
  - [1.1 Створення VM](#11-створення-vm)
  - [1.2 Встановлення Ubuntu](#12-встановлення-ubuntu)
  - [1.3 Мережа (Bridged Adapter)](#13-мережа-bridged-adapter)
  - [1.4 Snapshots](#14-snapshots)
  - [1.5 Зміна параметрів VM](#15-зміна-параметрів-vm)
- [Частина 2: Vagrant](#частина-2-vagrant)
  - [2.1 Проблема Apple Silicon](#21-проблема-apple-silicon)
  - [2.2 Vagrantfile](#22-vagrantfile)

---

## Частина 1: VirtualBox

### 1.1 Створення VM

Створено віртуальну машину з параметрами згідно завдання:

| Параметр | Значення            |
| -------- | ------------------- |
| Name     | TestVM              |
| OS       | Ubuntu (ARM 64-bit) |
| RAM      | 2048 MB (2 GB)      |
| CPU      | 2 cores             |
| Disk     | 20 GB, VDI format   |
| EFI      | Enabled             |

![VM Name and OS](screenshots/01-vm-name-os.png)

![VM Hardware](screenshots/02-vm-hardware.png)

![VM Disk](screenshots/03-vm-disk.png)

![ISO Selected](screenshots/04-vm-iso-selected.png)

![VM Created](screenshots/05-vm-created-nat.png)

![Network Bridged](screenshots/06-network-bridged.png)

![Storage ISO](screenshots/08-storage-iso.png)

![VM Final Config](screenshots/09-vm-final-config.png)

---

### 1.2 Встановлення Ubuntu

Встановлено Ubuntu Server 24.04.3 LTS (ARM64).

**Процес інсталяції:**

![Ubuntu Keyboard](screenshots/10-ubuntu-keyboard.png)

![Ubuntu Type](screenshots/11-ubuntu-type.png)

![Ubuntu Mirror](screenshots/12-ubuntu-mirror.png)

![Ubuntu Storage LVM](screenshots/13-ubuntu-storage-lvm.png)

![Ubuntu Storage Summary](screenshots/14-ubuntu-storage-summary.png)

![Ubuntu Profile](screenshots/15-ubuntu-profile.png)

![Ubuntu Pro Skip](screenshots/16-ubuntu-pro-skip.png)

**SSH Configuration:**

Обрано встановлення OpenSSH Server для віддаленого доступу.

![SSH Configuration](screenshots/17-ubuntu-ssh.png)

**Server Snaps:**

Ubuntu пропонує популярні серверні пакети (microk8s, docker, aws-cli тощо). Пропустив на цьому етапі.

![Server Snaps](screenshots/18-ubuntu-snaps.png)

**Завершення інсталяції:**

![Installation Complete](screenshots/19-ubuntu-complete.png)

![Remove ISO](screenshots/20-ubuntu-remove-iso.png)

**Перший вхід у систему:**

![Ubuntu Login](screenshots/21-ubuntu-login.png)

![First Login](screenshots/22-ubuntu-first-login.png)

**Системна інформація після входу:**

```
Ubuntu 24.04.3 LTS (GNU/Linux 6.8.0-88-generic aarch64)
IPv4: 192.168.1.138
Memory usage: 9%
Disk usage: 45.1% of 9.75GB
```

---

### 1.3 Мережа (Bridged Adapter)

Налаштовано Bridged Adapter для отримання IP-адреси з локальної мережі.

**Чому Bridged Adapter?**

| Тип         | Опис                    | Коли використовувати               |
| ----------- | ----------------------- | ---------------------------------- |
| NAT         | VM "ховається" за host  | За замовчуванням, тільки інтернет  |
| **Bridged** | VM отримує IP з роутера | Коли VM має бути доступна в мережі |
| Host-only   | Приватна мережа host↔VM | Ізольоване тестування              |

VM отримала IP **192.168.1.138** з домашнього роутера і доступна для SSH з host-машини.

---

### 1.4 Snapshots

**Snapshot** — знімок стану VM в певний момент часу. Дозволяє повернутися до збереженого стану.

**Створення snapshot:**

![Snapshot Tab](screenshots/23-snapshot-tab.png)

![Create Snapshot](screenshots/24-snapshot-create.png)

![Snapshot Created](screenshots/25-snapshot-created.png)

**Тестування snapshot:**

1. Створено snapshot "Clean Install"
2. Створено тестовий файл:

```bash
touch ~/testfile.txt
echo "Hello DevOps" > ~/testfile.txt
cat ~/testfile.txt
ls -la ~/testfile.txt
```

![Test File Created](screenshots/26-snapshot-test-file.png)

3. Вимкнено VM та відновлено snapshot:

![Powered Off](screenshots/27-snapshot-powered-off.png)

![Restore Dialog](screenshots/28-snapshot-restore-dialog.png)

4. Після відновлення — файл зник:

![File Gone](screenshots/29-snapshot-restored.png)

```bash
ls -la ~/testfile.txt
# ls: cannot access '/home/gleb/testfile.txt': No such file or directory
```

✅ **Snapshot працює коректно!**

---

### 1.5 Зміна параметрів VM

**Нові параметри згідно завдання:**

| Параметр | Було  | Стало |
| -------- | ----- | ----- |
| RAM      | 2 GB  | 4 GB  |
| CPU      | 2     | 4     |
| Disk     | 20 GB | 30 GB |

**RAM та CPU:**

Settings → System → Motherboard/Processor

![RAM 4096 MB](screenshots/30-settings-ram.png)

![CPU 4](screenshots/31-settings-cpu.png)

**Диск:**

File → Virtual Media Manager → Properties → Resize

![Media Manager](screenshots/32-media-manager.png)

![Resize to 30GB](screenshots/33-disk-resize-gui.png)

**Розширення файлової системи всередині Ubuntu:**

Диск збільшено на рівні VirtualBox, але Ubuntu ще не бачить нового простору. Потрібно розширити:

```bash
# Перевірка до розширення
df -h
```

![Before Resize](screenshots/34-df-before.png)

```bash
# Розширити фізичний том LVM
sudo pvresize /dev/sda3

# Розширити логічний том на 100% вільного простору
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

# Розширити файлову систему
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# Перевірити результат
df -h
```

![After Resize](screenshots/35-df-after-resize.png)

**Результат:** Диск розширено з 9.8G до 17G (використання знизилось з 48% до 28%).

---

## Частина 2: Vagrant (Додаткове завдання)

### 2.1 Проблема Apple Silicon

Vagrant + VirtualBox на Apple Silicon (M1/M2/M3) має обмеження:

- Більшість Vagrant boxes для VirtualBox створені для x86 архітектури
- ARM64 boxes для VirtualBox практично відсутні
- VirtualBox на Apple Silicon працює через емуляцію (повільно)

**Рішення:** Використано QEMU provider для Vagrant, який нативно підтримує ARM64.

### 2.2 Vagrantfile

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "perk/ubuntu-2204-arm64"

  config.vm.provider "qemu" do |qe|
    qe.memory = "2048"
    qe.cpus = 2
    qe.arch = "aarch64"
    qe.machine = "virt,accel=hvf,highmem=on"
    qe.cpu = "host"
    qe.net_device = "virtio-net-pci"
  end

  # Web server з Nginx
  config.vm.define "web" do |web|
    web.vm.hostname = "web-server"
    web.vm.network "forwarded_port", guest: 80, host: 8080
    web.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y nginx
      echo "<h1>Hello from Vagrant Web Server</h1>" > /var/www/html/index.html
      systemctl enable nginx
      systemctl start nginx
    SHELL
  end

  # Private network VM
  config.vm.define "private" do |priv|
    priv.vm.hostname = "private-server"
  end

  # Static IP VM
  config.vm.define "static" do |stat|
    stat.vm.hostname = "static-server"
  end
end
```

### 2.3 Результати

**Статус всіх VM:**

```bash
vagrant status
```

![Vagrant Status](screenshots/36-vagrant-status.png)

Всі три VM запущені з QEMU provider:

- `web` — running (qemu)
- `private` — running (qemu)
- `static` — running (qemu)

---

**Web VM з Nginx:**

```bash
vagrant ssh web
systemctl status nginx
```

![Vagrant Web](screenshots/37-vagrant-web-nginx.png)

- Ubuntu 22.04.5 LTS (ARM64)
- Nginx: **active (running)**
- Hostname: `web-server`

---

**Private VM:**

```bash
vagrant ssh private
curl --version
hostname
```

![Vagrant Private](screenshots/38-vagrant-private.png)

- curl встановлено
- Hostname: `private-server`

---

**Static VM:**

```bash
vagrant ssh static
hostname
```

![Vagrant Static](screenshots/39-vagrant-static.png)

- Hostname: `static-server`

---

**Основні команди Vagrant:**

```bash
# Статус всіх VM
vagrant status

# Запуск всіх VM
vagrant up

# Запуск конкретної VM
vagrant up web

# SSH до VM
vagrant ssh web

# Зупинка всіх VM
vagrant halt

# Знищення всіх VM
vagrant destroy -f
```

---

## Висновки

1. **VirtualBox** — потужний інструмент для локальної віртуалізації
2. **Snapshots** — критично важлива функція для безпечного тестування
3. **LVM** — дозволяє гнучко керувати дисковим простором
4. **Vagrant** — Infrastructure as Code для локальних середовищ
5. **Apple Silicon** вимагає альтернативних рішень (QEMU, UTM, Parallels)

---

## Використані технології

- VirtualBox 7.x (Apple Silicon)
- Ubuntu Server 24.04.3 LTS (ARM64)
- Vagrant 2.x з QEMU provider
- LVM (Logical Volume Manager)
