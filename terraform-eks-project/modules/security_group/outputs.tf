#####################################
# Security Group Outputs
#####################################
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.main.id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.main.name
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.main.arn
}

output "security_group_vpc_id" {
  description = "The VPC ID where the security group is created"
  value       = aws_security_group.main.vpc_id
}

output "security_group_owner_id" {
  description = "The owner ID of the security group"
  value       = aws_security_group.main.owner_id
}