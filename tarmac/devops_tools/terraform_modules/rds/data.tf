data "aws_caller_identity" "current" {
}

# Allow Lambda roles to have Cloudwatch logs access
data "template_file" "rds_lambdas_cw_access" {
  template = file("${path.module}/iam_policies/rds_lambdas_cw_access.json")
}

data "template_file" "rds_iam_auth" {
  template = file("${path.module}/iam_policies/rds_iam_auth.json")

  vars = {
    db_account_arn = "arn:aws:rds-db:${var.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.postgresql.resource_id}/${var.db_iam_auth_username}"
  }
}

# SQL automation S3 bucket policy
data "template_file" "s3_access_sql_automation" {
  template = file("${path.module}/iam_policies/s3_access_sql_automation.json")

  vars = {
    aws_account_id            = data.aws_caller_identity.current.account_id
    sql_automation_bucket_arn = aws_s3_bucket.sql_automation.arn
    s3_vpc_endpoint_id        = var.s3_vpc_endpoint_id
    aws_organization_id       = "Your-Org-ID"
  }
}

data "template_file" "rds_enhanced_assume_role" {
  template = file("${path.module}/iam_policies/rds_enhanced_assume_role.json")
}

# SQL automation Lambda IAM role access to SQL S3 bucket
data "template_file" "sql_automation_role_s3" {
  template = file("${path.module}/iam_policies/sql_automation_role_s3.json")

  vars = {
    sql_automation_bucket_arn = aws_s3_bucket.sql_automation.arn
  }
}