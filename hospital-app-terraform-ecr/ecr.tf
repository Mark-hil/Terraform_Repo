# ecr.tf
resource "aws_ecr_repository" "app" {
  name                 = "hospital-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}