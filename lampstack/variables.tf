variable "db_username" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "Zone_id" {
  description = "Id of your hosted zone"
  type        = string
}

variable "protocol" {
  description = "Protocol for the SNS subscription"
  type        = string
}

variable "endpoint" {
  description = "Endpoint for the SNS subscription"
  type        = string
}