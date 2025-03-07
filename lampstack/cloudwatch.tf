resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/fargate-task"
  retention_in_days = 7  # Set the log retention period 
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name          = "rds-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80   # Trigger alarm if CPU > 80%
  alarm_description   = "Alarm when RDS CPU exceeds 80%"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }
  alarm_actions = []  # Add SNS topic ARN or other actions here
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm" {
  alarm_name          = "ecs-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80   # Trigger alarm if CPU > 80%
  alarm_description   = "Alarm when ECS CPU exceeds 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.fargate_cluster.name
    ServiceName = aws_ecs_service.fargate_service.name
  }
  alarm_actions = []  # Add SNS topic ARN or other actions here
}