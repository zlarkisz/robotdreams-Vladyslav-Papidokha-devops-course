# =============================================================================
# OUTPUTS.TF — Вихідні дані проекту
# =============================================================================
#
# Після terraform apply ці значення виведуться в термінал.
# Це зручно для отримання IP-адрес, ID ресурсів тощо.
#
# Також ці значення можна використати в інших Terraform проектах.
# =============================================================================


# -----------------------------------------------------------------------------
# VPC Outputs
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID створеного VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR блок VPC"
  value       = module.vpc.vpc_cidr
}


# -----------------------------------------------------------------------------
# Subnet Outputs
# -----------------------------------------------------------------------------

output "public_subnet_id" {
  description = "ID публічної підмережі"
  value       = module.subnets.public_subnet_id
}

output "private_subnet_id" {
  description = "ID приватної підмережі"
  value       = module.subnets.private_subnet_id
}


# -----------------------------------------------------------------------------
# EC2 Public Server Outputs
# -----------------------------------------------------------------------------

output "public_server_id" {
  description = "ID публічного сервера"
  value       = module.ec2_public.instance_id
}

output "public_server_public_ip" {
  description = "Публічна IP-адреса (для доступу з інтернету)"
  value       = module.ec2_public.public_ip
}

output "public_server_private_ip" {
  description = "Приватна IP-адреса публічного сервера"
  value       = module.ec2_public.private_ip
}


# -----------------------------------------------------------------------------
# EC2 Private Server Outputs
# -----------------------------------------------------------------------------

output "private_server_id" {
  description = "ID приватного сервера"
  value       = module.ec2_private.instance_id
}

output "private_server_private_ip" {
  description = "Приватна IP-адреса приватного сервера"
  value       = module.ec2_private.private_ip
}


# -----------------------------------------------------------------------------
# Корисна інформація
# -----------------------------------------------------------------------------

output "ssh_connection_command" {
  description = "Команда для підключення до публічного сервера"
  value       = "ssh -i <your-key.pem> ec2-user@${module.ec2_public.public_ip}"
}

output "web_url" {
  description = "URL веб-сервера"
  value       = "http://${module.ec2_public.public_ip}"
}