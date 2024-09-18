output "rds_endpoint" {
  value = aws_db_instance.mysql-rds.endpoint
  description = "The endpoint for the RDS instance"
}
