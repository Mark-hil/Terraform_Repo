#####################################
# VPC Outputs
#####################################
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the created VPC"
  value       = aws_vpc.main.cidr_block
}

#####################################
# Subnet Outputs
#####################################
output "public_subnets" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

#####################################
# Security Group Outputs
#####################################
output "default_sg_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}

#####################################
# Route Table Outputs
#####################################
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}