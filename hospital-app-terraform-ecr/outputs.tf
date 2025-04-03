output "load_balancer_url" {
  value = "http://${aws_lb.app.dns_name}"
}

output "database_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}