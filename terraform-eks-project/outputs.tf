#####################################
# State Management Outputs
#####################################
output "state_bucket" {
  description = "Name of the S3 bucket storing Terraform state"
  value       = module.s3_backend.bucket_name
}

output "state_lock_table" {
  description = "Name of the DynamoDB table for state locking"
  value       = module.s3_backend.dynamodb_table_name
}

#####################################
# Network Outputs
#####################################
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = var.vpc_cidr
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

#####################################
# Security Outputs
#####################################
output "security_group_id" {
  description = "ID of the main security group"
  value       = module.security_group.security_group_id
}

#####################################
# EKS Cluster Outputs
#####################################
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_endpoint" {
  description = "Endpoint URL of the EKS cluster API server"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "eks_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

#####################################
# EC2 Instance Outputs
#####################################
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

#####################################
# Kubernetes Application Outputs
#####################################
output "k8s_namespace" {
  description = "Kubernetes namespace where the application is deployed"
  value       = module.k8s.namespace
}

output "k8s_service_name" {
  description = "Name of the Kubernetes service"
  value       = module.k8s.service_name
}

output "application_url" {
  description = "URL of the application LoadBalancer"
  value       = "http://${module.k8s.load_balancer_ip}"
}

#####################################
# Monitoring Outputs
#####################################
output "cloudwatch_log_group" {
  description = "Name of the CloudWatch Log Group for EKS logs"
  value       = aws_cloudwatch_log_group.eks_logs.name
}

# output "firehose_stream" {
#   description = "Name of the Kinesis Firehose delivery stream for logs"
#   value       = aws_kinesis_firehose_delivery_stream.eks_logs.name
# }
