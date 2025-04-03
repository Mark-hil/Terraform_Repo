variable "cluster_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

# variable "app_repo_url" {
#   type = string
# }
variable "execution_role_arn" {
  description = "IAM Role ARN for ECS task execution"
  type        = string
}

variable "repository_url" {
  description = "ECR repository URL for the container image"
  type        = string
}

variable "region" {
  description = "AWS region for VPC endpoints"
  type        = string
  default     = "eu-west-1"
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to associate with the ECS service"
  type        = string
}

variable "db_address" {
  description = "The address of the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}
