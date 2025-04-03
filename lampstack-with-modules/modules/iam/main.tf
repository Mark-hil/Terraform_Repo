resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name  # Fix: use "role" instead of "roles"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Logs to S3 IAM Role
resource "aws_iam_role" "cloudwatch_to_s3" {
  name = "cloudwatch-to-s3-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_to_s3" {
  name        = "cloudwatch-to-s3-policy"
  description = "Allow CloudWatch Logs to write to S3"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_to_s3" {
  role       = aws_iam_role.cloudwatch_to_s3.name
  policy_arn = aws_iam_policy.cloudwatch_to_s3.arn
}
