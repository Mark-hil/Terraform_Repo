variable "repository_name" {
  type = string
}

variable "execution_role_arn" {
  description = "IAM Role ARN for ECS task execution"
  type        = string
}

variable "repository_url" {
  description = "The URL of the ECR repository containing the container image"
  type        = string
}
