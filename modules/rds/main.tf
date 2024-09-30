resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "my-db-subnet-group"
  subnet_ids = var.database_subnets
  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "mysql-rds" {
  allocated_storage       = 5
  db_name                 = "MyDBInstance"
  engine                  = "mysql"
  engine_version          = "5.7.44"
  instance_class          = "db.t3.micro"
  username                = "dbakaiusername"
  password                = "akaistark1ngothanhsang"
  skip_final_snapshot     = true
  backup_retention_period = 7
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-group.name
  tags = {
    Name = "My DB"
  }
}

resource "aws_db_instance" "replica-mysql-rds" {
  instance_class          = "db.t3.micro"
  skip_final_snapshot     = true
  backup_retention_period = 7
  replicate_source_db     = aws_db_instance.mysql-rds.identifier
  tags = {
    replica = "true"
    env     = "Dev"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = var.vpc_id
  name        = "DB Subnet SG"
  description = "Allow connection from app subnets"


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    # security_groups = var.private_security_groups
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Database Security Group"
  }
}
