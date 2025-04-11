#####################################
# Network Configuration
#####################################
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for EKS nodes"
  type        = list(string)
}

#####################################
# Cluster Configuration
#####################################
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

#####################################
# Tagging Configuration
#####################################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
#####################################
# Node Group Configuration
#####################################
variable "node_instance_types" {
  description = "List of instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}