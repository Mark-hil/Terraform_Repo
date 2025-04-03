variable "alb_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "logs_bucket_id" {
  description = "ID of the S3 bucket where ALB access logs will be stored"
  type        = string
}
