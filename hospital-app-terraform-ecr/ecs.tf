resource "aws_ecs_cluster" "cluster" {
  name = "hospital-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "hospital-app"
  cpu = 1024
  memory = 2048
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_execution.arn
  
  container_definitions = jsonencode([{
    name      = "app",
    image     = "${aws_ecr_repository.app.repository_url}:v1.3.1",
    essential = true,
    portMappings = [{ containerPort = 80 }],
    environment = [
      { name = "DB_HOST", value = aws_db_instance.mysql.endpoint },
      { name = "DB_USER", value = var.db_username },
      { name = "DB_PASS", value = var.db_password }
    ]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "hospital-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups = [aws_security_group.ecs.id]
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = 80
  }
}