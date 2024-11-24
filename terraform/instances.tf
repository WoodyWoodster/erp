resource "aws_instance" "jumpbox" {
  ami                    = "ami-04dd23e62ed049936" # Ubuntu 24.04 LTS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jumpbox_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name
  user_data              = <<-EOF
                  #!/bin/bash
                  sudo apt update
                  sudo apt upgrade -y
                  sudo apt install -y docker.io curl git

                  # Add ubuntu user to docker group
                  sudo usermod -a -G docker ubuntu

                  # Add private key
                  mkdir -p /home/ubuntu/.ssh
                  echo "${tls_private_key.bastion_ssh_key.private_key_pem}" > /home/ubuntu/.ssh/id_rsa
                  chmod 600 /home/ubuntu/.ssh/id_rsa
                  chown -R ubuntu:ubuntu /home/ubuntu/.ssh
                  EOF
  tags = {
    Name = "gndwrk-erp-jumpbox"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-04dd23e62ed049936" # Ubuntu 24.04 LTS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.bastion_key.key_name
  user_data              = <<-EOF
                  #!/bin/bash
                  sudo apt update
                  sudo apt upgrade -y
                  sudo apt install -y docker.io curl git openssh-server
                  sudo usermod -a -G docker ubuntu
                  EOF
  tags = {
    Name = "gndwrk-erp-web"
  }
}
