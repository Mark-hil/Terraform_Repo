output "alb_arn" {
  value = aws_alb.ecs_alb.arn
}

output "alb_dns_name" {
  value = aws_alb.ecs_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.ecs_tg.arn
}
