# =============================================================================
# MAIN.TF — Головний файл проекту
# =============================================================================
#
# Тут ми ВИКОРИСТОВУЄМО модулі, які створили раніше.
# Це як виклик функцій з параметрами.
#
# Структура:
#   1. Data source — отримуємо AMI (образ ОС)
#   2. Module VPC — створюємо мережу
#   3. Module Subnets — створюємо підмережі
#   4. Module EC2 (public) — сервер з доступом до інтернету
#   5. Module EC2 (private) — ізольований сервер
# =============================================================================


# -----------------------------------------------------------------------------
# Data Source: Отримуємо AMI (образ операційної системи)
# -----------------------------------------------------------------------------
# Data source — це спосіб ОТРИМАТИ інформацію з AWS, а не створювати ресурс.
#
# Навіщо?
#   AMI ID різний в кожному регіоні і постійно оновлюється.
#   Замість хардкодити "ami-0123456789", ми шукаємо найновіший Amazon Linux.
#
# Це як: "AWS, дай мені ID найновішого Amazon Linux 2023 в моєму регіоні"

data "aws_ami" "amazon_linux" {
  # Взяти найновіший AMI, якщо є кілька результатів
  most_recent = true

  # Власник AMI — amazon (офіційні образи)
  owners = ["amazon"]

  # Фільтри для пошуку потрібного AMI
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]  # Amazon Linux 2023
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Тип віртуалізації (сучасний стандарт)
  }
}


# -----------------------------------------------------------------------------
# Module: VPC
# -----------------------------------------------------------------------------
# Викликаємо наш модуль VPC.
# Це як виклик функції: createVPC(cidr, name)

module "vpc" {
  # Шлях до модуля (відносний)
  source = "./modules/vpc"

  # Передаємо параметри (значення для variables.tf модуля)
  vpc_cidr = var.vpc_cidr
  vpc_name = "${var.project_name}-vpc"

  tags = {
    Environment = "dev"
  }
}


# -----------------------------------------------------------------------------
# Module: Subnets
# -----------------------------------------------------------------------------
# Викликаємо модуль підмереж.
# Він отримує vpc_id з модуля VPC — так модулі "спілкуються".

module "subnets" {
  source = "./modules/subnets"

  # Ці значення беремо з OUTPUT модуля VPC
  # module.vpc.vpc_id — це значення з outputs.tf модуля vpc
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id

  # Параметри підмереж
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  project_name        = var.project_name

  tags = {
    Environment = "dev"
  }
}


# -----------------------------------------------------------------------------
# Module: EC2 Public (сервер в публічній підмережі)
# -----------------------------------------------------------------------------
# Цей сервер буде доступний з інтернету.
# Матиме публічну IP-адресу і відкриті порти SSH, HTTP, HTTPS.

module "ec2_public" {
  source = "./modules/ec2"

  instance_name = "${var.project_name}-public-server"
  instance_type = var.instance_type
  ami_id        = data.aws_ami.amazon_linux.id  # AMI з data source
  subnet_id     = module.subnets.public_subnet_id  # Публічна підмережа
  vpc_id        = module.vpc.vpc_id
  is_public     = true  # Відкрити порти SSH, HTTP, HTTPS

  tags = {
    Environment = "dev"
    Role        = "web-server"
  }
}


# -----------------------------------------------------------------------------
# Module: EC2 Private (сервер в приватній підмережі)
# -----------------------------------------------------------------------------
# Цей сервер НЕ доступний з інтернету.
# Немає публічної IP, порти закриті для зовнішнього трафіку.
# Типове використання: база даних, внутрішній API.

module "ec2_private" {
  source = "./modules/ec2"

  instance_name = "${var.project_name}-private-server"
  instance_type = var.instance_type
  ami_id        = data.aws_ami.amazon_linux.id
  subnet_id     = module.subnets.private_subnet_id  # Приватна підмережа
  vpc_id        = module.vpc.vpc_id
  is_public     = false  # НЕ відкривати порти з інтернету

  tags = {
    Environment = "dev"
    Role        = "database"
  }
}