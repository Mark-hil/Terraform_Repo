output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}
# output "execution_role_arn" {
#   description = "IAM role ARN for ECS task execution (if managed in this module)"
#   value       = aws_iam_role.ecs_execution_role.arn
# }