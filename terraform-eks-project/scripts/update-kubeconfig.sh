#!/bin/bash

# Script to update kubeconfig for EKS cluster access

# Exit on any error
set -e

# Get cluster name and region from Terraform output
CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
REGION=$(terraform output -raw aws_region)

# Update kubeconfig
echo "Updating kubeconfig for cluster: $CLUSTER_NAME"
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"

# Test connection
echo "Testing cluster connection..."
kubectl get nodes

echo "Kubeconfig updated successfully!"
