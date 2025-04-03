# Load Balancer
resource "aws_lb" "app" {
  name               = "hospital-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  enable_deletion_protection = false # Set to true for production
}

# Target Group with proper health checks
resource "aws_lb_target_group" "app" {
  name        = "hospital-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-404" # Accepts 200-404 as healthy
  }

  # Required for ECS services
  depends_on = [aws_lb.app]
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Load Balancer Security Group (updated)
resource "aws_security_group" "lb" {
  name        = "hospital-app-lb-sg"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hospital-app-lb-sg"
  }
}

# NEW: ECS Tasks Security Group (must be added)
resource "aws_security_group" "ecs_tasks" {
  name        = "hospital-app-ecs-tasks-sg"
  description = "Allow inbound from ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hospital-app-ecs-sg"
  }
}