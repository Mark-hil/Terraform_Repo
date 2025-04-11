#####################################
# VPC Configuration Variables
#####################################
variable "vpc_cidr" {
  description = "CIDR block for VPC network"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid VPC CIDR block."
  }
}

variable "availability_zones" {
  description = "List of availability zones for subnet creation"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

#####################################
# Resource Naming Variables
#####################################
variable "env_prefix" {
  description = "Environment prefix for resource naming (e.g., dev, staging, prod)"
  type        = string
}

#####################################
# Security Variables
#####################################
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed in security group ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All elements must be valid CIDR blocks."
  }
}

#####################################
# Tagging Variables
#####################################
variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}