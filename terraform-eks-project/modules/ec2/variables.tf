variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "env_prefix" {
  description = "Environment prefix for resource naming"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to EC2 resources"
  type        = map(string)
  default     = {}
}