provider "aws" {
  region = var.aws_region
}

# -- VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
}

# -- ECR Module
module "ecr" {
  source = "./modules/ecr"
  repository_name = var.ecr_repository_name
  execution_role_arn = module.iam.ecs_execution_role_arn
  repository_url     = module.ecr.repository_url
}

# -- ALB Module
module "alb" {
  source            = "./modules/alb"
  alb_name          = var.alb_name
  public_subnet_ids = module.vpc.public_subnets
  security_group_id = module.vpc.ecs_sg_id
  vpc_id            = module.vpc.vpc_id
  logs_bucket_id    = module.s3.bucket_id
}

# -- ECS Module
module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = var.ecs_cluster_name
  private_subnet_ids = module.vpc.private_subnets
  security_group_id  = module.vpc.ecs_sg_id
  repository_url     = module.ecr.repository_url
  execution_role_arn = module.iam.ecs_execution_role_arn
  target_group_arn   = module.alb.target_group_arn
  db_address         = module.rds.db_address
  db_username        = var.db_username
  db_password        = var.db_password
  db_name            = var.db_name
}

# -- RDS Module
module "rds" {
  source            = "./modules/rds"
  db_subnet_ids     = module.vpc.private_subnets
  security_group_id = module.vpc.ecs_sg_id
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
}

# -- S3 Module
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

# -- CloudWatch Module
module "cloudwatch" {
  source              = "./modules/cloudwatch"
  log_group_name      = var.log_group_name
  logs_destination_arn = module.s3.bucket_arn
  cloudwatch_role_arn = module.iam.cloudwatch_to_s3_role_arn
}

module "iam" {
  source = "./modules/iam"
}
