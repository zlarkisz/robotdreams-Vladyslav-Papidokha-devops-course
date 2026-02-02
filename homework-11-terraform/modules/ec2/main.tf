# =============================================================================
# EC2 MODULE — MAIN (створення ресурсів)
# =============================================================================
#
# Цей модуль створює:
#   1. Security Group — файрвол для сервера
#   2. EC2 Instance — сам сервер
# =============================================================================


# -----------------------------------------------------------------------------
# Ресурс: Security Group
# -----------------------------------------------------------------------------
# Security Group — це віртуальний файрвол для EC2.
#
# КЛЮЧОВІ ПРАВИЛА:
#   1. За замовчуванням ВСЕ вхідне заблоковане
#   2. За замовчуванням ВСЕ вихідне дозволене
#   3. Security Group — stateful: якщо дозволив вхід, відповідь автоматично дозволена
#
# Приклад:
#   Ти дозволив вхідний трафік на порт 80 (HTTP).
#   Коли хтось відкриває твій сайт, сервер відправляє відповідь.
#   Ця відповідь автоматично дозволена (не потрібно окреме правило).

resource "aws_security_group" "this" {
  # Назва Security Group (має бути унікальною в VPC)
  name        = "${var.instance_name}-sg"

  # Опис — видно в AWS Console
  description = "Security group for ${var.instance_name}"

  # В якому VPC створюємо
  vpc_id      = var.vpc_id

  # ===== ВИХІДНИЙ ТРАФІК (egress) =====
  # Дозволяємо серверу ходити куди завгодно.
  # Без цього сервер не зможе:
  #   - Завантажувати пакети (apt install, yum install)
  #   - Робити API запити
  #   - Відповідати на вхідні з'єднання

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0           # 0 означає "всі порти"
    to_port     = 0
    protocol    = "-1"        # -1 означає "всі протоколи"
    cidr_blocks = ["0.0.0.0/0"]  # 0.0.0.0/0 означає "весь світ"
  }

  tags = merge(
    { Name = "${var.instance_name}-sg" },
    var.tags
  )
}


# -----------------------------------------------------------------------------
# Ресурс: Security Group Rule — SSH (порт 22)
# -----------------------------------------------------------------------------
# Дозволяє підключатися до сервера по SSH.
# Створюємо ТІЛЬКИ якщо is_public = true.
#
# count — умовне створення ресурсу:
#   count = 1 — створити ресурс
#   count = 0 — НЕ створювати ресурс
#   var.is_public ? 1 : 0 — якщо is_public true, то 1, інакше 0

resource "aws_security_group_rule" "ssh" {
  # Створюємо тільки для публічних серверів
  count = var.is_public ? 1 : 0

  # Тип правила: ingress = вхідний трафік
  type              = "ingress"

  # Діапазон портів (22-22 = тільки порт 22)
  from_port         = 22
  to_port           = 22

  # Протокол: tcp (SSH працює по TCP)
  protocol          = "tcp"

  # Звідки дозволяємо: з будь-якої IP-адреси
  # УВАГА: в продакшені тут має бути ТВОЯ IP-адреса, не 0.0.0.0/0!
  cidr_blocks       = ["0.0.0.0/0"]

  # До якої Security Group додаємо правило
  security_group_id = aws_security_group.this.id

  description       = "SSH access"
}


# -----------------------------------------------------------------------------
# Ресурс: Security Group Rule — HTTP (порт 80)
# -----------------------------------------------------------------------------
# Дозволяє доступ до веб-сервера по HTTP.

resource "aws_security_group_rule" "http" {
  count = var.is_public ? 1 : 0

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
  description       = "HTTP access"
}


# -----------------------------------------------------------------------------
# Ресурс: Security Group Rule — HTTPS (порт 443)
# -----------------------------------------------------------------------------
# Дозволяє доступ до веб-сервера по HTTPS (захищене з'єднання).

resource "aws_security_group_rule" "https" {
  count = var.is_public ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
  description       = "HTTPS access"
}


# -----------------------------------------------------------------------------
# Ресурс: EC2 Instance (сам сервер)
# -----------------------------------------------------------------------------
# Нарешті створюємо сам сервер!

resource "aws_instance" "this" {
  # AMI — образ операційної системи (Amazon Linux, Ubuntu, тощо)
  ami = var.ami_id

  # Тип інстансу — потужність сервера
  instance_type = var.instance_type

  # В якій підмережі запустити
  subnet_id = var.subnet_id

  # Які Security Groups застосувати
  # Це список, бо до EC2 можна прикріпити кілька SG
  vpc_security_group_ids = [aws_security_group.this.id]

  # User Data — скрипт, який виконається при першому запуску сервера
  # Це як "автоматична установка" — сервер сам налаштується
  user_data = <<-EOF
    #!/bin/bash
    # Цей скрипт виконається автоматично при старті сервера

    # Оновлюємо пакети
    dnf update -y

    # Встановлюємо nginx (веб-сервер)
    dnf install nginx -y

    # Створюємо просту HTML-сторінку
    echo "<h1>Hello from ${var.instance_name}!</h1>" > /usr/share/nginx/html/index.html

    # Запускаємо nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}
