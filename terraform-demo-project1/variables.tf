variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "terraform-demo"
}