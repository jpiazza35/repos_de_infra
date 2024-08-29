data "aws_partition" "current" {
}

data "aws_caller_identity" "current" {
}

data "template_file" "aws_config_role" {
  template = file("${path.module}/policies/aws_config_role_policy.json")
}

data "template_file" "s3_bucket_config" {
  template = file("${path.module}/policies/config_s3_bucket_policy.json")
  vars = {
    bucket_config       = aws_s3_bucket.bucket_config.arn
    current_account_id  = data.aws_caller_identity.current.account_id
    aws_organization_id = "Your-Org-ID"
  }
}

data "template_file" "ssm_remediation_iam_role" {
  template = file("${path.module}/policies/ssm_remediation_iam_role_policy.json")
}

data "template_file" "ssm_remediation_iam_permissions" {
  template = file("${path.module}/policies/ssm_remediation_iam_policy.json")
}

data "template_file" "s3_encryption_remediation_document" {
  template = file("${path.module}/policies/s3_encryption_remediation.yaml")
}

data "template_file" "config_compliance_lambda" {
  template = file("${path.module}/policies/config_compliance_lambda_policy.json")
}
