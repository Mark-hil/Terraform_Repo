resource "aws_alb" "ecs_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.security_group_id]
  
  # Enable access logs
  access_logs {
    bucket  = var.logs_bucket_id
    prefix  = "logs/alb"
    enabled = true
  }
}

# Create a target group for the ECS service
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }
}

# Create a listener to route traffic to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
