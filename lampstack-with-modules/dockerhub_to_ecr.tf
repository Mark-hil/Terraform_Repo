resource "null_resource" "docker_build_push" {
  depends_on = [module.ecr]

  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${module.ecr.repository_url}
      # Pull the Docker Hub image
      docker pull markhill97/hospital_app:v1.3.0
      # Tag it for ECR
      docker tag markhill97/hospital_app:v1.3.1 ${module.ecr.repository_url}:v1.3.1
      # Push the tagged image to ECR
      docker push ${module.ecr.repository_url}:v1.3.1
    EOT
    interpreter = ["bash", "-c"]
  }
}
