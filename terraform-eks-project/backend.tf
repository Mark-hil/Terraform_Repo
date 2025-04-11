# terraform {
#   backend "s3" {
#     bucket         = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "terraform-locks-${random_id.bucket_suffix.hex}"
#     encrypt        = true
#   }
# }