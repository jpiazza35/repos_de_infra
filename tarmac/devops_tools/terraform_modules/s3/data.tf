data "aws_caller_identity" "current" {
}

data "template_file" "s3_access_dashboard_vault" {
  template = file("${path.module}/iam_policies/s3_access_dashboard_vault.json")
  vars = {
    s3_dashboard_vault = element(concat(aws_s3_bucket.dashboard_vault.*.arn, tolist([""])), 0)
    s3_vpc_endpoint_id = var.s3_vpc_endpoint_id
    aws_account_id     = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "s3_access_dashboard_vault_prod" {
  template = file("${path.module}/iam_policies/s3_access_dashboard_vault_prod.json")
  vars = {
    s3_dashboard_vault       = element(concat(aws_s3_bucket.dashboard_vault.*.arn, tolist([""])), 0)
    s3_vpc_endpoint_id       = var.s3_vpc_endpoint_id
    aws_account_id           = data.aws_caller_identity.current.account_id
    example_machine_iam_user = var.example_machine_iam_user
  }
}