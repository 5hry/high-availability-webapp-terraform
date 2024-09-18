output "private_security_groups" {
  value = aws_security_group.private_subnet_sg[*].id
}