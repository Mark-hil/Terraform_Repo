variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }

variable "aws_region" {
  description = "AWS region for VPC endpoints"
  type        = string
  default     = "eu-west-1"
}
