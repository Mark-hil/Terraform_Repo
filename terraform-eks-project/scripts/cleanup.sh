#!/bin/bash

# Cleanup script for destroying infrastructure

# Exit on any error
set -e

# Confirm destruction
read -p "Are you sure you want to destroy all resources? This cannot be undone! (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborted."
    exit 1
fi

# Get state bucket name
BUCKET_NAME=$(terraform output -raw state_bucket 2>/dev/null || echo "")

# Destroy infrastructure
echo "Destroying infrastructure..."
terraform destroy -auto-approve

# If state bucket exists, empty and delete it
if [ ! -z "$BUCKET_NAME" ]; then
    echo "Emptying and deleting state bucket: $BUCKET_NAME"
    aws s3 rm "s3://$BUCKET_NAME" --recursive
    aws s3api delete-bucket --bucket "$BUCKET_NAME"
fi

echo "Cleanup complete!"
