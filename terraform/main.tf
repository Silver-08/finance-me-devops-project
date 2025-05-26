provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                         = "ami-0454207e5367abf01"
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  key_name                    = "my-key"

  tags = {
    Name = "app-server"
  }
}

resource "aws_instance" "monitor_server" {
  ami                         = "ami-0454207e5367abf01"
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  key_name                    = "my-key"

  tags = {
    Name = "monitor-server"
  }
}

output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "monitor_server_public_ip" {
  value = aws_instance.monitor_server.public_ip
}
