#####################################
# S3 Bucket Outputs
#####################################
output "bucket_name" {
  description = "Name of the created S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.state.arn
}

output "bucket_region" {
  description = "Region where the S3 bucket is created"
  value       = aws_s3_bucket.state.region
}

#####################################
# DynamoDB Table Outputs
#####################################
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table used for state locking"
  value       = aws_dynamodb_table.locks.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.locks.arn
}

#####################################
# Backend Configuration
#####################################
output "backend_config" {
  description = "Configuration map for Terraform backend configuration"
  value = {
    bucket         = aws_s3_bucket.state.id
    dynamodb_table = aws_dynamodb_table.locks.name
    region         = aws_s3_bucket.state.region
    encrypt        = true
  }
}