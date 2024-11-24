resource "aws_instance" "jumpbox" {
  ami                    = "ami-04dd23e62ed049936" # Ubuntu 24.04 LTS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jumpbox_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "gndwrk-erp"
  user_data              = <<-EOF
                  #!/bin/bash
                  sudo apt update
                  sudo apt upgrade -y
                  sudo apt install -y docker.io curl git

                  # Add ubuntu user to docker group
                  sudo usermod -a -G docker ubuntu
                  
                  # Write the private key to a file
                  echo "${data.aws_ssm_parameter.private_key.value}" > /home/ubuntu/gndwrk-erp.pem
                  chmod 400 /home/ubuntu/gndwrk-erp.pem
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
  key_name               = "gndwrk-erp"
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
