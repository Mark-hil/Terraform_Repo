#!/bin/bash
set -e

# Get resource names from terraform outputs
BUCKET_NAME=$(terraform output -raw s3_backend_bucket_name)
TABLE_NAME=$(terraform output -raw s3_backend_dynamodb_table_name)
REGION=$(aws configure get region)

# Create backend configuration
cat > backend.tf <<EOF
terraform {
  backend "s3" {
    bucket         = "${BUCKET_NAME}"
    key            = "terraform.tfstate"
    region         = "${REGION}"
    dynamodb_table = "${TABLE_NAME}"
    encrypt        = true
    
    # Enable state locking
    lock_table     = "${TABLE_NAME}"
    
    # Configure lock timeouts
    lock_timeout   = "5m"
    
    # Enable consistency
    force_path_style = true
    skip_region_validation = true
    skip_credentials_validation = true
  }
}
EOF