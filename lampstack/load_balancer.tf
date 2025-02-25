resource "aws_lb_target_group" "fargate_tg" {
  name     = "fargate-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"  # Set target type to "ip" for Fargate

  health_check {
    path                = "/"
    port                = 8000
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb" "fargate_alb" {
  name               = "fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "fargate-alb"
  }
}

resource "aws_lb_listener" "fargate_listener" {
  load_balancer_arn = aws_lb.fargate_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_tg.arn  # Forward traffic to the target group
  }
}