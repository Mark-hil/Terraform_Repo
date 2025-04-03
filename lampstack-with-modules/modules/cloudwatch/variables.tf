variable "log_group_name" {
  type = string
}

variable "logs_destination_arn" {
  description = "ARN of the destination for log exports (e.g., S3 bucket or Lambda function)"
  type        = string
}

variable "cloudwatch_role_arn" {
  description = "ARN of the IAM role that allows CloudWatch to write to the destination"
  type        = string
}
