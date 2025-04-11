#####################################
# General Configuration
#####################################
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-west-1"

  validation {
    condition     = can(regex("^[a-z][a-z]-[a-z]+-[0-9]$", var.aws_region))
    error_message = "Must be a valid AWS region name."
  }
}

variable "env_prefix" {
  description = "Environment prefix for all resources (dev/stage/prod)"
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.env_prefix)
    error_message = "Environment must be one of: dev, stage, prod."
  }
}

variable "project_name" {
  description = "Name of the project, used in resource naming and tags"
  type        = string
}

#####################################
# Network Configuration
#####################################
variable "vpc_cidr" {
  description = "CIDR block for VPC network"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid VPC CIDR block."
  }
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to SSH into EC2 instances"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.allowed_ssh_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All elements must be valid CIDR blocks."
  }
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed for HTTP/HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Consider restricting this in production

  validation {
    condition     = alltrue([for cidr in var.allowed_http_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All elements must be valid CIDR blocks."
  }
}

#####################################
# EKS Configuration
#####################################
variable "cluster_name" {
  description = "Name of the EKS cluster, will be prefixed with env_prefix"
  type        = string
  default     = null

  validation {
    condition     = var.cluster_name == null || can(regex("^[a-zA-Z][-a-zA-Z0-9]*$", var.cluster_name))
    error_message = "Cluster name must begin with letter and only contain alphanumeric characters and hyphens."
  }
}

#####################################
# Port Configuration
#####################################
locals {
  # Standard ports
  ports = {
    # HTTP ports
    http = {
      container = 80
      service   = 80
    }
    # SSH port
    ssh = 22
    # Application ports
    app = {
      container = 80
      service   = 80
    }
    # Health check ports
    health = {
      container = 80
      service   = 80
    }
  }

  # Port ranges
  port_ranges = {
    all = {
      from = 0
      to   = 0
    }
    http = {
      from = 80
      to   = 80
    }
    ssh = {
      from = 22
      to   = 22
    }
  }
}

#####################################
# Tags Configuration
#####################################
variable "tags" {
  description = "Additional tags to add to all resources"
  type        = map(string)
  default     = {}
}