resource "aws_s3_bucket" "storage" {
  bucket = "${var.bucket_name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Configure server-side encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "storage_encryption" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configure lifecycle rules for logs
resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.storage.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    # Move logs to Infrequent Access storage after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Delete logs after 90 days
    expiration {
      days = 90
    }

    # Apply this rule to all log files
    filter {
      prefix = "logs/"
    }
  }
}

# Create a bucket policy to allow AWS services to write logs
resource "aws_s3_bucket_policy" "logs_policy" {
  bucket = aws_s3_bucket.storage.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::156460612806:root"  # ELB service account for eu-west-1
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.storage.arn}/logs/alb/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "logging.s3.amazonaws.com",
            "logs.amazonaws.com"
          ]
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.storage.arn}/logs/*"
      }
    ]
  })
}
