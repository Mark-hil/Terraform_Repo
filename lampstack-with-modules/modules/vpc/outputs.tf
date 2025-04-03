output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}
