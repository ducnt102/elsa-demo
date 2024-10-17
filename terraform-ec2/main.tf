# main.tf

provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-ec2-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEagP4mtEuz1hOh8bp0dXSKcjbTcJoiJO64csSssw9wr"  # Ensure this path points to your SSH public key
}

resource "aws_instance" "ubuntu_server" {
  ami           = "ami-04505e74c0741db8d"  # Ubuntu 22.04 LTS AMI (replace with your region's AMI)
  instance_type = "t2.medium"               # Change the instance type if needed
  key_name      = aws_key_pair.my_key.key_name

  # Enable SSH access
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Initialize instance with basic setup
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip git
    sudo pip3 install ansible
  EOF

  tags = {
    Name = "Ubuntu22.04-Server"
  }
}

# Security Group to allow SSH access
resource "aws_security_group" "allow_ssh_" {
  name        = "allow_ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
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

# Output the public IP address of the EC2 instance
output "instance_public_ip" {
  description = "The public IP address of the Ubuntu server"
  value       = aws_instance.ubuntu_server.public_ip
}

