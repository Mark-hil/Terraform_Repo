#!/bin/bash

# Setup script for initializing the EKS cluster and installing dependencies

# Exit on any error
set -e

# Check prerequisites
echo "Checking prerequisites..."

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check Terraform
if ! command -v terraform &> /dev/null; then
    echo "Terraform is not installed. Please install it first."
    exit 1
fi

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install it first."
    exit 1
fi

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Create S3 backend
echo "Creating S3 backend..."
terraform apply -target=module.s3_backend -auto-approve

# Update backend configuration
echo "Updating backend configuration..."
BUCKET_NAME=$(terraform output -raw state_bucket)
TABLE_NAME=$(terraform output -raw state_lock_table)
REGION=$(aws configure get region)

# Update backend.tf
sed -i "s/bucket\s*=\s*\".*\"/bucket = \"$BUCKET_NAME\"/" backend.tf
sed -i "s/dynamodb_table\s*=\s*\".*\"/dynamodb_table = \"$TABLE_NAME\"/" backend.tf
sed -i "s/region\s*=\s*\".*\"/region = \"$REGION\"/" backend.tf

# Re-initialize with backend
echo "Re-initializing Terraform with S3 backend..."
terraform init -force-copy

echo "Setup complete! You can now run 'terraform plan' and 'terraform apply'"
