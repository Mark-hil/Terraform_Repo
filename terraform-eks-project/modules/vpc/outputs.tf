output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

# output "private_subnets" {
#   value = aws_subnet.private[*].id
# }

# output "default_sg_id" {
#   value = aws_security_group.default.id
# }
output "default_sg_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}