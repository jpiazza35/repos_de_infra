data "aws_caller_identity" "current" {
}

data "template_file" "cloudtrail_kms_policy" {
  template = file("${path.module}/iam_policies/cloudtrail-kms-policy.json")
  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "cw_log_groups_kms_policy" {
  template = file("${path.module}/iam_policies/cw-log-groups-kms-policy.json")
  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "sqs_kms_policy" {
  template = file("${path.module}/iam_policies/sqs-kms-policy.json")
  vars = {
    aws_account_id            = data.aws_caller_identity.current.account_id
    proxy_prod_aws_account_id = var.proxy_prod_aws_account_id
    proxy_dev_aws_account_id  = var.proxy_dev_aws_account_id
    proxy_test_aws_account_id = var.proxy_test_aws_account_id
    master_aws_account_id     = var.master_aws_account_id
  }
}

data "template_file" "s3_kms_policy" {
  template = file("${path.module}/iam_policies/s3-kms-policy.json")
  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "sns_kms_policy" {
  template = file("${path.module}/iam_policies/sns-kms-policy.json")
  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "sns_kms_policy_logging" {
  template = file("${path.module}/iam_policies/sns-kms-logging-policy.json")
  vars = {
    aws_account_id            = data.aws_caller_identity.current.account_id
    proxy_prod_aws_account_id = var.proxy_prod_aws_account_id
    proxy_dev_aws_account_id  = var.proxy_dev_aws_account_id
    proxy_test_aws_account_id = var.proxy_test_aws_account_id
    master_aws_account_id     = var.master_aws_account_id
  }
}
