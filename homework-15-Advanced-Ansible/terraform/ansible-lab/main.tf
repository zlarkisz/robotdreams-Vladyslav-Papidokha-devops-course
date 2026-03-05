# ==================================================
# Provider — говоримо Terraform використовувати AWS
# ==================================================
provider "aws" {
  region = "eu-central-1"
}

# ==================================================
# Data source — отримуємо останній Ubuntu 24.04 AMI
# Ansible найкраще працює з Ubuntu (є Python за замовч.)
# ==================================================
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (офіційний акаунт Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ==================================================
# Security Group — дозволяємо SSH і HTTP
# Ansible підключається через SSH (порт 22)
# ==================================================
resource "aws_security_group" "ansible_lab" {
  name        = "ansible-lab-sg"
  description = "Security group for Ansible lab servers"

  # SSH — для Ansible підключення
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP — для Nginx який встановимо через Ansible
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Вихідний трафік — дозволяємо все (для apt install)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "ansible-lab-sg"
    Project = "ansible-homework"
  }
}

# ==================================================
# EC2 інстанси — створюємо 2 сервери
# count = 2 означає "створи цей ресурс двічі"
# ==================================================
resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free tier

  # SSH ключ — використовуємо вже існуючий в AWS
  key_name               = "ansible-lab-key"
  vpc_security_group_ids = [aws_security_group.ansible_lab.id]

  tags = {
    Name    = "ansible-web-${count.index + 1}" # web-1, web-2
    Role    = "webserver"
    Project = "ansible-homework"
    # Цей тег важливий для Dynamic Inventory!
    Ansible = "true"
  }
}

# ==================================================
# Output — виводимо IP адреси після створення
# Ці IP підемуть в Ansible inventory
# ==================================================
output "web_servers_public_ips" {
  description = "Public IP addresses of web servers"
  value       = aws_instance.web[*].public_ip
}

output "ssh_commands" {
  description = "SSH commands to connect to servers"
  value       = [for ip in aws_instance.web[*].public_ip : "ssh -i ~/.ssh/gitlab_ci_key ubuntu@${ip}"]
}
