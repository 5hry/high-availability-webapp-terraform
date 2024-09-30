output "private_security_groups" {
  value = aws_security_group.private_subnet_sg[*].id
}

output "bastion_IP" {
  value = aws_instance.bastion_ec2.public_ip
}