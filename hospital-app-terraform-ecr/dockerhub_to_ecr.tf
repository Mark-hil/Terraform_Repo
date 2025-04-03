resource "null_resource" "pull_from_dockerhub_and_push_to_ecr" {
  triggers = {
    # Force this to run every time (or use a hash of the Docker image)
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      # Authenticate with ECR
      aws ecr get-login-password --region ${data.aws_region.current.name} | \
      docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com

      # Pull from Docker Hub
      docker pull markhill97/hospital_app:v1.3.1  # Replace with your Docker Hub image

      # Tag for ECR
      docker tag hospital_app:v1.3.1 ${aws_ecr_repository.app.repository_url}:latest

      # Push to ECR
      docker push ${aws_ecr_repository.app.repository_url}:v1.3.1
    EOF
  }
}

# Required data sources for account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}