resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = var.log_group_name
  retention_in_days = 14  
}


