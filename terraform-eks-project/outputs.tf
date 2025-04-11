output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ec2_public_ip" {
  value = module.ec2.instance_public_ip
}
# output "id" {
#   description = "The ID of the security group"
#   value       = aws_security_group.main.id
# }

