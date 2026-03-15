output "monitoring_server_ip" {
  value = aws_instance.monitoring.public_ip
}

output "web_server_ip" {
  value = aws_instance.web.public_ip
}

output "web_server_private_ip" {
  description = "Prometheus використовує private IP для scraping всередині VPC"
  value       = aws_instance.web.private_ip
}