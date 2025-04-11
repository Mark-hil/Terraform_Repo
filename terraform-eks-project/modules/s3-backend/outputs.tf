output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.state.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB lock table"
  value       = aws_dynamodb_table.locks.name
}