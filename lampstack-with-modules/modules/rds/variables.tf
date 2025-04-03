variable "db_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}
