resource "aws_sns_topic" "sns_notifications" {
  count = var.create_sns ? 1 : 0

  name              = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-alerts-topic"
  kms_master_key_id = var.sns_kms_key_alias
  tags              = var.tags
}

resource "aws_sns_topic_policy" "sns_notifications" {
  count = var.create_sns ? 1 : 0

  arn    = aws_sns_topic.sns_notifications[count.index].arn
  policy = data.template_file.sns_notifications.rendered
}

resource "aws_sns_topic" "sns_codecommit" {
  count = var.create_sns_codecommit ? 1 : 0

  name = "codestar-notifications-${var.tags["Environment"]}-${var.tags["Application"]}-codecommit"
  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_codecommit" {
  count = var.create_sns_codecommit ? 1 : 0

  arn    = aws_sns_topic.sns_codecommit[count.index].arn
  policy = data.template_file.sns_codecommit.rendered
}

resource "aws_sns_topic_subscription" "sns_codecommit" {
  count = var.create_sns_codecommit ? length(var.sns_subscription_email_list) : 0

  topic_arn = aws_sns_topic.sns_codecommit[0].arn
  protocol  = "email"
  endpoint  = element(var.sns_subscription_email_list, count.index)
}