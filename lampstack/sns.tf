# Create an SNS topic
resource "aws_sns_topic" "alarm_notifications" {
  name = "alarm-notifications-topic"
}

# Subscribe to the SNS topic (e.g., via email)
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = var.protocol
  endpoint  = "chillop.learn@gmail.com"  # Replace with your email address
}