variable "cluster_endpoint" {
  description = "Endpoint for EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Certificate authority data for EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudWatch log group"
  type        = map(string)
  default     = {}
}