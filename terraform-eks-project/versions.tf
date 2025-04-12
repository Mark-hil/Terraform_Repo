#####################################
# Terraform Configuration
#####################################
terraform {
  # Terraform version constraint
  required_version = ">= 1.0.0"

  required_providers {
    # AWS provider for infrastructure resources
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Major version 5
    }

    # Random provider for generating unique identifiers
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Major version 3
    }

    # Kubernetes provider for managing K8s resources
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Major version 2
    }

    # Helm provider for managing Helm charts
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0" # Major version 2
    }
  }
}