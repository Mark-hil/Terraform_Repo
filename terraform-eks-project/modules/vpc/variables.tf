variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}