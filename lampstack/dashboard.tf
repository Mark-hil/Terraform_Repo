resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "ecs-rds-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              aws_db_instance.mysql.id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"  # Replace with your region
          title  = "RDS CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              aws_ecs_cluster.fargate_cluster.name,
              "ServiceName",
              aws_ecs_service.fargate_service.name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"  # Replace with your region
          title  = "ECS CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              aws_db_instance.mysql.id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"  # Replace with your region
          title  = "RDS Free Storage Space"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              aws_ecs_cluster.fargate_cluster.name,
              "ServiceName",
              aws_ecs_service.fargate_service.name
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"  # Replace with your region
          title  = "ECS Memory Utilization"
        }
      }
    ]
  })
}