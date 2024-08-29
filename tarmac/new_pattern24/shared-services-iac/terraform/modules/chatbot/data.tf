# Chatbot assume policy
data "aws_iam_policy_document" "chatbot_assume" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["chatbot.amazonaws.com"]
      type        = "Service"
    }
    effect = "Allow"
  }
}

# Chatbot policy
data "aws_iam_policy_document" "chatbot" {
  statement {
    effect = "Allow"
    actions = [
      "logs:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}

# Chatbot cloudformation template file
data "local_file" "cloudformation_template" {
  filename = "${path.module}/chatbot_cloudformation.yml"
}

# Policy for sns topic to publish to chatbot
data "aws_iam_policy_document" "chatbot_sns" {
  version   = "2012-10-17"
  policy_id = "ChatBotSns"
  statement {
    sid       = "AllowSnsPublish"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["sns:Publish"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    sid    = "AllowSnsFullAccessOnTopic"
    effect = "Allow"
    actions = [
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:AddPermission",
      "sns:RemovePermission",
      "sns:DeleteTopic",
      "sns:Subscribe",
      "sns:ListSubscriptionsByTopic",
      "sns:Publish",
      "sns:Receive"
    ]
    resources = ["arn:aws:sns:*:*:slack-chatbot"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}
