output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}
