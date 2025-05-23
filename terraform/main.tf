provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deploy" {
  key_name   = "your-key"
  public_key = file("~/.ssh/your-key.pub")
}

resource "aws_security_group" "sg" {
  name        = "devops-sg"
  description = "SSH, HTTP, Monitoring ports"
  ingress = [
    { from_port = 22,   to_port = 22,   protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 9090, to_port = 9090, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  ]
}

locals { names = ["ci-server","monitoring-server"] }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter { name = "name", values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] }
}

resource "aws_instance" "servers" {
  count                  = length(local.names)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.deploy.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = { Name = local.names[count.index] }
}

output "ci_server_ip" {
  value = aws_instance.servers[0].public_ip
}

output "monitoring_server_ip" {
  value = aws_instance.servers[1].public_ip
}
