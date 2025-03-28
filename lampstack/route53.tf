# Route 53 Record for the ALB
resource "aws_route53_record" "app" {
  zone_id = "Z1047104T79A1B7OOZH0" # Replace with your existing hosted zone ID
  name    = "hms.com"  # Replace with your domain name
  type    = "A"

  alias {
    name                   = aws_lb.fargate_alb.dns_name
    zone_id                = aws_lb.fargate_alb.zone_id
    evaluate_target_health = true
  }
}