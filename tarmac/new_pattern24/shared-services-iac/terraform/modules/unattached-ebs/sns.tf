resource "aws_sns_topic" "unattached_ebs" {
  name = "unattached-ebs"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.unattached_ebs.arn
  protocol  = "email"
  endpoint  = var.sns_email
}
