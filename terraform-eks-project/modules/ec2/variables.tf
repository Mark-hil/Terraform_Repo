#####################################
# Network Configuration
#####################################
variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs for the instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

#####################################
# Instance Configuration
#####################################
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z][1-9][.][a-z0-9]+$", var.instance_type))
    error_message = "Instance type must be a valid EC2 instance type (e.g., t3.micro, m5.large)."
  }
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GB."
  }
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring (CloudWatch)"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "Enable EBS optimization for the instance"
  type        = bool
  default     = true
}

#####################################
# Naming and Tagging
#####################################
variable "env_prefix" {
  description = "Environment prefix for resource naming (e.g., prod, dev, staging)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.env_prefix))
    error_message = "Environment prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}