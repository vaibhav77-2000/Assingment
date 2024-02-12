provider "aws" {
  region = var.region
}

resource "aws_instance" "example_instance" {
  ami             = "ami-03f4878755434977f"
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  vpc_security_group_ids = [var.security_group_id] 
  associate_public_ip_address = true

  tags = {
    Name = "SShInstance"
  }
}

output "instance_id" {
  value = aws_instance.example_instance.id
}

output "public_ip_address" {
  value = aws_instance.example_instance.public_ip
}
