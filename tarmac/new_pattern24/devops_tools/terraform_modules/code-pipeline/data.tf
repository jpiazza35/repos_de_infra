data "aws_caller_identity" "current" {
}

data "template_file" "pipeline_policy" {
  template = file("${path.module}/iam_policies/pipeline-policy.json")
  vars = {
    aws_account_id  = data.aws_caller_identity.current.account_id
    shared_services = var.shared_services_aws_account_id
    pipeline_role   = aws_iam_role.code_pipeline_role.arn
  }
}

data "template_file" "cwe_pipeline_policy" {
  template = file("${path.module}/iam_policies/cwe-pipeline-policy.json")
  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = var.region
    pipeline_name  = aws_codepipeline.codepipeline.id
  }
}

data "template_file" "s3_access_pipeline_source" {
  template = file("${path.module}/iam_policies/s3-pipeline-source.json")
  vars = {
    s3_pipeline_source  = aws_s3_bucket.s3_pipeline_source.arn
    s3_vpc_endpoint_id  = var.s3_vpc_endpoint_id
    aws_organization_id = "Your-Org-ID"
    aws_account_id      = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "s3_access_code_pipeline" {
  template = file("${path.module}/iam_policies/s3-code-pipeline.json")
  vars = {
    s3_code_pipeline    = aws_s3_bucket.s3_code_pipeline.arn
    s3_vpc_endpoint_id  = var.s3_vpc_endpoint_id
    aws_organization_id = "Your-Org-ID"
    shared_services     = var.shared_services_aws_account_id
    aws_account_id      = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "s3_access_trail_logs" {
  template = file("${path.module}/iam_policies/s3-cloud-trail-logs.json")
  vars = {
    aws_account_id     = data.aws_caller_identity.current.account_id
    s3_trail_logs      = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.arn, tolist([""])), 0)
    s3_vpc_endpoint_id = var.s3_vpc_endpoint_id
  }
}

data "template_file" "s3_cw_pipeline_source" {
  template = file("${path.module}/iam_policies/cwe-s3-policy.json")
  vars = {
    s3_pipeline_source = aws_s3_bucket.s3_pipeline_source.id
  }
}

data "template_file" "assume_code_pipeline" {
  template = file("${path.module}/iam_policies/assume-code-pipeline.json")
}

data "template_file" "assume_cwe" {
  template = file("${path.module}/iam_policies/assume-cwe.json")
}

data "template_file" "cloudtrail_cw_logs" {
  template = file("${path.module}/iam_policies/cloudtrail-cw-logs.json")
  vars = {
    aws_account_id    = data.aws_caller_identity.current.account_id
    region            = var.region
    cw_log_group_name = element(concat(aws_cloudwatch_log_group.pipeline_trail.*.name, tolist([""])), 0),

  }
}

data "template_file" "assume_cloudtrail" {
  template = file("${path.module}/iam_policies/assume-cloudtrail.json")
}