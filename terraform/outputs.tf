output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "jumpbox_private_ip" {
  value = aws_instance.jumpbox.vpc_security_group_ids
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}

resource "local_file" "private_key" {
  content         = tls_private_key.bastion_ssh_key.private_key_pem
  filename        = "gndwrk.pem"
  file_permission = "0600"
}
