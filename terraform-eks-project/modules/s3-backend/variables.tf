variable "bucket_prefix" {
  description = "Prefix for S3 bucket name (will add random suffix)"
  type        = string
  default     = "tf-state"
}

variable "dynamodb_table_name" {
  description = "Name for DynamoDB lock table"
  type        = string
  default     = "terraform-locks"
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed with contents"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default     = {}
}