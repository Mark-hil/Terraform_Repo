#!/bin/bash

# Script to set up logging infrastructure

# Exit on any error
set -e

# Get log group name and firehose stream name from Terraform output
LOG_GROUP=$(terraform output -raw cloudwatch_log_group)
FIREHOSE_STREAM=$(terraform output -raw firehose_stream)

# Enable CloudWatch logging
echo "Enabling CloudWatch logging for EKS cluster..."
aws eks update-cluster-config \
    --name $(terraform output -raw eks_cluster_name) \
    --region $(terraform output -raw aws_region) \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'

# Create subscription filter for CloudWatch to Kinesis
echo "Setting up CloudWatch Logs subscription filter..."
aws logs put-subscription-filter \
    --log-group-name "$LOG_GROUP" \
    --filter-name "EKSLogsToS3" \
    --filter-pattern "" \
    --destination-arn "arn:aws:firehose:$(terraform output -raw aws_region):$(aws sts get-caller-identity --query Account --output text):deliverystream/$FIREHOSE_STREAM"

echo "Logging setup complete!"
