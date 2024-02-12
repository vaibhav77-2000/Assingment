
resource "aws_instance" "server" {
   ami = "ami-03f4878755434977f"
   instance_type = "t2.micro"
   key_name = "demo"
   vpc_security_group_ids = [aws_security_group.demo_vpc_sg.id]
   subnet_id = aws_subnet.demo_vpc_public_subnet.id
   associate_public_ip_address = true
  
   tags = {
     Name = "Linux-Server"
  }
}
