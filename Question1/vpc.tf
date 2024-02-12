resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_subnet" "demo_vpc_public_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "demo_vpc_public_subnet"
  }
}

resource "aws_subnet" "demo_vpc_private_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "demo_vpc_private_subnet"
  }
}

resource "aws_internet_gateway" "demo_vpc_ig" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo_vpc_ig"
  }
}

resource "aws_route_table" "demo_vpc_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_vpc_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.demo_vpc_ig.id
  }

  tags = {
    Name = "demo_vpc_private_rt"
  }
}


resource "aws_security_group" "demo_vpc_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.demo_vpc.id

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


