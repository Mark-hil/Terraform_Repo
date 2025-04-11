variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudWatch log group"
  type        = map(string)
  default     = {}
}