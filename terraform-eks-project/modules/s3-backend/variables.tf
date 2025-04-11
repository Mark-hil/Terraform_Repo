#####################################
# S3 Bucket Configuration
#####################################
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name (a random suffix will be added)"
  type        = string
  default     = "tf-state"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_prefix))
    error_message = "Bucket prefix must contain only lowercase letters, numbers, and hyphens, and must start and end with a letter or number."
  }
}

variable "force_destroy" {
  description = "Allow the bucket to be destroyed even if it contains state files (use with caution)"
  type        = bool
  default     = false
}

#####################################
# DynamoDB Table Configuration
#####################################
variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table used for state locking"
  type        = string
  default     = "terraform-locks"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{3,255}$", var.dynamodb_table_name))
    error_message = "DynamoDB table name must be between 3 and 255 characters and contain only letters, numbers, underscores, dots, and hyphens."
  }
}

#####################################
# Resource Tagging
#####################################
variable "tags" {
  description = "Map of tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s\\-\\.\\:/@]+$", k)) && can(regex("^[\\w\\s\\-\\.\\:/@]+$", v))])
    error_message = "Tags must contain only letters, numbers, spaces, and the following characters: -._:/@"
  }
}