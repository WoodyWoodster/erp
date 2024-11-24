provider "aws" {
  region = "us-west-2"
}

provider "tls" {
}

resource "tls_private_key" "bastion_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "gndwrk-bastion-key"
  public_key = tls_private_key.bastion_ssh_key.public_key_openssh
}
