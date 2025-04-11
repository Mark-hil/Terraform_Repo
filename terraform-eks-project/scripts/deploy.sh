#!/bin/bash
set -e

echo "Initializing Terraform..."
terraform init

terraform fmt

echo "Planning changes..."
terraform plan -out=tfplan

echo "Calculating cost estimation for all resources..."
infracost breakdown --path . --show-skipped

echo "Review the cost estimation above."
echo "Do you want to proceed with the deployment? (y/n)"
read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    echo "Applying changes..."
    terraform apply tfplan
    echo "Deployment complete!"
else
    echo "Deployment cancelled"
    exit 0
fi