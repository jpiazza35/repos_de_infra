data "aws_caller_identity" "current" {
}

data "template_file" "DsKlqh" {
  template = file("${path.module}/iam_policies/guardrails_DsKlqh.json")
}

data "template_file" "fsPKWB" {
  template = file("${path.module}/iam_policies/guardrails_fsPKWB.json")
}

data "template_file" "HHmslj" {
  template = file("${path.module}/iam_policies/guardrails_HHmslj.json")
}

data "template_file" "hrVqLt" {
  template = file("${path.module}/iam_policies/guardrails_hrVqLt.json")
}

data "template_file" "yBOtDK" {
  template = file("${path.module}/iam_policies/guardrails_yBOtDK.json")
}

data "template_file" "assume_lambda_role_policy" {
  template = file("${path.module}/iam_policies/assume_lambda_role_policy.json")
}