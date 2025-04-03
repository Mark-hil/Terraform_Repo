output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "cloudwatch_to_s3_role_arn" {
  value = aws_iam_role.cloudwatch_to_s3.arn
}
