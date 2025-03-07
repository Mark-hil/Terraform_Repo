resource "aws_ecs_cluster" "fargate_cluster" {
  name = "fargate-cluster"
}

resource "aws_ecs_task_definition" "fargate_task" {
  family                   = "fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "hospital_app"
      image     = "markhill97/hospital_app:v1.3.1"  # Replace with your Docker Hub image
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
          awslogs-group         = "/ecs/fargate-task"
          awslogs-region       = "eu-west-1"  # Replace with your region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "DB_SERVER"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_USER"
          value = var.db_username  # Use the variable
        },
        {
          name  = "DB_PASS"
          value = var.db_password  # Use the variable
        },
        {
          name  = "DB_NAME"
          value = var.db_name  # Use the variable
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "fargate_service" {
  name            = "fargate-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_tg.arn
    container_name   = "hospital_app"  # Ensure this matches the container name in the task definition
    container_port   = 80
  }

  depends_on = [aws_lb_listener.fargate_listener]  # Ensure the listener is created first
}