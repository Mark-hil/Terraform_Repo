#####################################
# S3 Backend Configuration
#####################################

# This backend configuration should be uncommented and updated
# after running 'terraform init' and creating the S3 bucket
# and DynamoDB table using the s3-backend module.

# terraform {
#   backend "s3" {
#     # S3 bucket for storing Terraform state
#     bucket         = "tf-state-<UNIQUE_SUFFIX>"  # Replace with actual bucket name
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"                 # Update with your desired region

#     # DynamoDB table for state locking
#     dynamodb_table = "terraform-locks"          # Replace with actual table name

#     # Security settings
#     encrypt        = true                       # Enable server-side encryption
#     kms_key_id     = ""                         # Optional: KMS key ARN for encryption

#     # Additional settings
#     workspace_key_prefix = "environment"        # Optional: Organize state by workspace
#   }
# }