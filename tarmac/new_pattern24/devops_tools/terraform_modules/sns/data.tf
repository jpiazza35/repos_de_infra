data "aws_caller_identity" "current" {
}

data "template_file" "sns_notifications" {
  template = file("${path.module}/iam_policies/sns-policy.json")

  vars = {
    aws_account_id            = data.aws_caller_identity.current.account_id
    region                    = var.region
    sns_topic_name            = element(concat(aws_sns_topic.sns_notifications.*.name, tolist([""])), 0)
    logging_aws_account_id    = var.logging_aws_account_id
    proxy_dev_aws_account_id  = var.proxy_dev_aws_account_id
    proxy_test_aws_account_id = var.proxy_test_aws_account_id
    proxy_prod_aws_account_id = var.proxy_prod_aws_account_id
    master_aws_account_id     = var.master_aws_account_id
  }
}

data "template_file" "sns_codecommit" {
  template = file("${path.module}/iam_policies/sns-codecommit-policy.json")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = var.region
    sns_topic_name = element(concat(aws_sns_topic.sns_codecommit.*.name, tolist([""])), 0)
  }
}