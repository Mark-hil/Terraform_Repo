# Provider Configuration
provider "aws" {
  region = var.aws_region
}

# Terraform Backend Configuration (uncomment after S3 bucket creation)
# terraform {
#   backend "s3" {
#     bucket         = "BUCKET_NAME"
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "TABLE_NAME"
#     encrypt        = true
#   }
# }

#####################################
# Core Infrastructure
#####################################
module "s3_backend" {
  source              = "./modules/s3-backend"
  bucket_prefix       = "${var.env_prefix}-terraform-state"
  dynamodb_table_name = "${var.env_prefix}-terraform-locks"
  tags                = local.common_tags
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  env_prefix = var.env_prefix
  tags       = local.common_tags
}

#####################################
# Security
#####################################
module "security_group" {
  source = "./modules/security_group"

  env_prefix               = var.env_prefix
  vpc_id                   = module.vpc.vpc_id
  allowed_ssh_cidr_blocks  = var.allowed_ssh_cidr_blocks
  allowed_http_cidr_blocks = var.allowed_http_cidr_blocks
  tags                     = local.common_tags
}

#####################################
# Compute Resources
#####################################
module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.public_subnets # Using public subnets for lab environment
  cluster_name    = "${var.env_prefix}-cluster"
  tags            = local.common_tags
}

module "ec2" {
  source          = "./modules/ec2"
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [module.security_group.security_group_id] # Updated reference
  env_prefix      = var.env_prefix
  tags            = local.common_tags
}

#####################################
# CloudWatch Monitoring
#####################################
# resource "aws_cloudwatch_log_group" "eks_logs" {
#   name              = "/aws/eks/${var.cluster_name}/cluster"
#   retention_in_days = 30
#   tags              = var.tags
# }
# Define common tags as locals
locals {
  common_tags = {
    Environment = var.env_prefix
    Project     = var.project_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }
}

#####################################
# Kubernetes
#####################################
module "k8s" {
  source                 = "./modules/k8s"
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_name           = module.eks.cluster_name
  namespace              = "app"
  app_name               = "poll-app"
  container_image        = "godcandidate/qr-code-app:latest"
  container_port         = 80
  service_port           = 80
  service_type           = "LoadBalancer"
  health_check_path      = "/"
  replicas               = 1
  environment_variables = {
    ENV      = "production"
    APP_NAME = "poll-app"
  }
}

# # Configure backend to use the created bucket
# terraform {
#   backend "s3" {
#     bucket         = "TEMPORARY_DUMMY_VALUE" # Will be replaced after first apply
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "TEMPORARY_DUMMY_VALUE"
#     encrypt        = true
#   }
# }