output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The public subnets IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The private subnets IDs"
  value       = module.vpc.private_subnets
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_id" {
  description = "The ECS cluster ID"
  value       = module.ecs.ecs_cluster_id
}

output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.db_endpoint
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "cloudwatch_log_group" {
  description = "The CloudWatch Log Group name"
  value       = module.cloudwatch.log_group_name
}
