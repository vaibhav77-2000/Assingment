provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "instance1" {
  ami             = "ami-03f4878755434977f"
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name
  subnet_id       =  "subnet-090553e5e228cd800"
  vpc_security_group_ids = [var.security_group_id] 
  

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              echo "This is instance 1" | sudo tee /var/www/html/index.html
              sudo service nginx start
              EOF

   tags = {
     Name = "Instance-1"
  }
}

resource "aws_instance" "instance2" {
  ami             = "ami-03f4878755434977f"
  instance_type   = var.instance_type
  key_name        = var.ssh_key_name
  subnet_id       = "subnet-090553e5e228cd800"
   vpc_security_group_ids = [var.security_group_id] 
  

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              echo "This is instance 2" | sudo tee /var/www/html/index.html
              sudo service nginx start
              EOF

  tags = {
     Name = "Instance-2"
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example_alb" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = ["subnet-090553e5e228cd800","subnet-09c19b4c26bee4767"]

  enable_deletion_protection = false

  enable_http2     = true
  enable_cross_zone_load_balancing = true

  idle_timeout = 60
}

resource "aws_lb_target_group" "target_group_instance1" {
  name     = "target-group-instance1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "attachment_instance1" {
  target_group_arn = aws_lb_target_group.target_group_instance1.arn
  target_id        = aws_instance.instance1.id
}

resource "aws_lb_target_group" "target_group_instance2" {
  name     = "target-group-instance2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "attachment_instance2" {
  target_group_arn = aws_lb_target_group.target_group_instance2.arn
  target_id        = aws_instance.instance2.id
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group_instance1.arn
    type             = "forward"
  }
}

output "alb_dns_name" {
  value = aws_lb.example_alb.dns_name
}
