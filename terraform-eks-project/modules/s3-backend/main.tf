#####################################
# Random Suffix Generator
#####################################
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

#####################################
# S3 Bucket Configuration
#####################################
resource "aws_s3_bucket" "state" {
  bucket        = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"
  force_destroy = var.force_destroy
  tags          = var.tags
}

# Enable versioning
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#####################################
# DynamoDB Lock Table
#####################################
resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

   point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}

# resource "aws_s3_bucket_policy" "state" {
#   bucket = aws_s3_bucket.state.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "DenyDelete"
#         Effect = "Deny"
#         Principal = "*"
#         Action = [
#           "s3:DeleteBucket",
#           "s3:DeleteObject",
#           "s3:DeleteObjectVersion"
#         ]
#         Resource = [
#           aws_s3_bucket.state.arn,
#           "${aws_s3_bucket.state.arn}/*"
#         ]
#         Condition = {
#           StringNotLike = {
#             "aws:PrincipalARN": ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin"]
#           }
#         }
#       }
#     ]
#   })
# }