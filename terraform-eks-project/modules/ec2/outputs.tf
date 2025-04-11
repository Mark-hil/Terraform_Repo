#####################################
# Instance Outputs
#####################################
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.web.arn
}

#####################################
# Network Outputs
#####################################
output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance (if enabled)"
  value       = try(aws_instance.web.public_ip, null)
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance (if enabled)"
  value       = try(aws_instance.web.public_dns, null)
}

#####################################
# Security Outputs
#####################################
output "security_groups" {
  description = "List of associated security group IDs"
  value       = aws_instance.web.vpc_security_group_ids
}

output "subnet_id" {
  description = "ID of the subnet where the instance is deployed"
  value       = aws_instance.web.subnet_id
}
