variable "aws_region" {
  default = "eu-central-1"
}

variable "key_name" {
  description = "SSH key pair name in AWS"
}

variable "my_ip" {
  description = "Your IP for SSH access (x.x.x.x/32)"
}