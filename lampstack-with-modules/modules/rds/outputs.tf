output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}
