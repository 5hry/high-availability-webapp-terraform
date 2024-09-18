output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "database_subnets" {
  value = aws_subnet.database_subnets[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

output "internet_gw" {
  value = aws_internet_gateway.igw
}

