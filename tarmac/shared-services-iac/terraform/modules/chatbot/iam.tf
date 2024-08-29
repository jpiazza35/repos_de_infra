# Chatbot IAM Role
resource "aws_iam_role" "chatbot" {
  name               = format("%s-%s-chatbot-role", lower(var.env), lower(var.app))
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume.json
}

# Chatbot policy
resource "aws_iam_policy" "chatbot" {
  name   = format("%s-%s-chatbot-policy", lower(var.env), lower(var.app))
  policy = data.aws_iam_policy_document.chatbot.json
}

resource "aws_iam_role_policy_attachment" "chatbot" {
  role       = aws_iam_role.chatbot.name
  policy_arn = aws_iam_policy.chatbot.arn
}