resource "aws_cloudformation_stack" "chatbot" {
  name          = format("%s-chatbot", lower(var.env))
  template_body = data.local_file.cloudformation_template.content
  parameters = {
    configurationName = format("%s-%s-chatbot", lower(var.env), lower(var.app))
    guardrailPolicies = join(",", var.guardrail_policies)
    roleArn           = aws_iam_role.chatbot.arn
    logLevel          = var.log_level
    slackChannelId    = join(",", var.slack_channel_id)
    slackWorkspaceId  = var.slack_workspace_id
    snsTopicArn       = aws_sns_topic.sns_topic.arn
  }
}
