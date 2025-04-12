#####################################
# General Configuration
#####################################
variable "env_prefix" {
  description = "Environment prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security group will be created"
  type        = string
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

#####################################
# Security Configuration
#####################################
variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Consider restricting this in production
}

variable "allowed_http_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#####################################
# Port Configuration
#####################################
variable "ssh_port" {
  description = "Port for SSH access"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "Port for HTTP access"
  type        = number
  default     = 80
}