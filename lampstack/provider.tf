terraform {
  required_providers {
    mysql = {
      source  = "winebarrel/mysql"
      version = "~> 1.10.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"  # Replace with your preferred region
}

provider "mysql" {
  endpoint = "127.0.0.1:3306"
  username = aws_db_instance.mysql.username
  password = aws_db_instance.mysql.password
}
