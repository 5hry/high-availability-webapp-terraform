resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "Project VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Public Subnets ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Private Subnets ${count.index + 1}"
  }
}

resource "aws_subnet" "database_subnets" {
  count             = length(var.database_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.database_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Database Subnets ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Project VPC Internet Gateway"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "2nd Route Table"
  }

}

resource "aws_route_table" "nat_gw_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "NAT Route Table"
  }
}

resource "aws_route_table_association" "public_subnets_association" {
  count = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.second_rt.id
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
}



resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"

  tags = {
    Name = "EIP NAT"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "NAT Gateway"
  }
}

resource "aws_route_table_association" "private_subnet_asso_natgw" {
  count = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.nat_gw_rt.id
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
}

