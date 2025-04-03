# variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "app_image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "db_username" {
  sensitive = true
}

variable "db_password" {
  sensitive = true
}
