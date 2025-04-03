variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ecr_repository_name" {
  description = "Name for the ECR repository"
  type        = string
  default     = "hospital_app"
}

variable "alb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
  default     = "ecs-alb"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-cluster"
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  default     = "password123"
}

variable "db_name" {
  description = "Name for the RDS database"
  type        = string
  default     = "hospital_db"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-storage-bucket"
}

variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
  default     = "/ecs/hospital-app"
}
