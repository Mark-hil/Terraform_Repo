resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = "hospital_app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  
  container_definitions = jsonencode([
    {
      name      = "hospital-app"
      image     = "${var.repository_url}:v1.3.1"
      essential = true
      
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/hospital-app"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "DB_SERVER"
          value = var.db_address 
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASS"
          value = var.db_password
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "hospital-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "hospital-app"
    container_port   = 80
  }
}
