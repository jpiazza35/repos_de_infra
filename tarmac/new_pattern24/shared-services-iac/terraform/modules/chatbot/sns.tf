resource "aws_sns_topic" "sns_topic" {
  name   = format("%s-%s-topic", lower(var.env), lower(var.app))
  policy = data.aws_iam_policy_document.chatbot_sns.json
}

resource "aws_sns_topic_subscription" "email_subscription" {
  for_each  = toset(var.list_email_address)
  endpoint  = each.value
  protocol  = "email"
  topic_arn = aws_sns_topic.sns_topic.arn
}
