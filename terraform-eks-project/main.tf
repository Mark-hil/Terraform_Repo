#####################################
# Provider Configuration
#####################################
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# Additional provider for ECR Public (required for us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = local.common_tags
  }
}

#####################################
# Local Variables
#####################################
locals {
  common_tags = {
    Environment = var.env_prefix
    Project     = var.project_name
    Terraform   = "true"
    ManagedBy   = "terraform"
  }

  cluster_name = coalesce(var.cluster_name, "${var.env_prefix}-cluster")
}

#####################################
# State Management
#####################################
module "s3_backend" {
  source = "./modules/s3-backend"

  # State bucket configuration
  bucket_prefix       = "${var.env_prefix}-terraform-state"
  dynamodb_table_name = "${var.env_prefix}-terraform-locks"
  tags                = local.common_tags
}

#####################################
# Network Infrastructure
#####################################
module "vpc" {
  source = "./modules/vpc"

  # VPC configuration
  vpc_cidr   = var.vpc_cidr
  env_prefix = var.env_prefix
  tags       = local.common_tags
}

#####################################
# Security Configuration
#####################################
module "security_group" {
  source = "./modules/security_group"

  # Security group configuration
  env_prefix               = var.env_prefix
  vpc_id                   = module.vpc.vpc_id
  allowed_ssh_cidr_blocks  = var.allowed_ssh_cidr_blocks
  allowed_http_cidr_blocks = var.allowed_http_cidr_blocks
  tags                     = local.common_tags
}

#####################################
# Container Infrastructure
#####################################
module "eks" {
  source = "./modules/eks"

  # EKS cluster configuration
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.public_subnets # Note: Using public subnets for demonstration
  cluster_name    = local.cluster_name
  tags            = local.common_tags

  depends_on = [module.vpc]
}

#####################################
# Application Infrastructure
#####################################
module "ec2" {
  source = "./modules/ec2"

  # EC2 instance configuration
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [module.security_group.security_group_id]
  env_prefix      = var.env_prefix
  tags            = local.common_tags

  depends_on = [module.vpc, module.security_group]
}

#####################################
# Monitoring and Logging
#####################################
resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 30
  tags              = local.common_tags

  depends_on = [module.eks]
}

# Kinesis Firehose for CloudWatch Logs to S3
resource "aws_kinesis_firehose_delivery_stream" "eks_logs" {
  name        = "${var.env_prefix}-eks-logs-to-s3"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = "${module.s3_backend.bucket_arn}/logs"

    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }

  tags = local.common_tags
}

#####################################
# Kubernetes Application
#####################################
module "k8s" {
  source = "./modules/k8s"

  # Cluster access configuration
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_name           = module.eks.cluster_name

  # Application configuration
  namespace       = "app"
  app_name        = "poll-app"
  container_image = "godcandidate/qr-code-app:latest"
  container_port  = local.ports.app.container
  service_port    = local.ports.app.service
  service_type    = "LoadBalancer"

  # Health check and scaling
  health_check_path = "/"
  replicas          = 1

  # Environment configuration
  environment_variables = {
    ENV      = var.env_prefix
    APP_NAME = "poll-app"
  }

  depends_on = [module.eks]
}