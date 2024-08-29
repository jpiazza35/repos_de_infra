resource "aws_iam_policy" "code_pipeline_policy" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-pipeline-policy"
  description = "This policy gives s3 and ECR access to the codepipeline role."
  path        = "/"
  policy      = data.template_file.pipeline_policy.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "code_pipeline_policy" {
  role       = aws_iam_role.code_pipeline_role.name
  policy_arn = aws_iam_policy.code_pipeline_policy.arn
}

resource "aws_iam_policy" "cwe_code_pipeline_policy" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-cwe-pipeline-policy"
  description = "This policy gives CW Events access trigger the pipeline."
  path        = "/"
  policy      = data.template_file.cwe_pipeline_policy.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cwe_code_pipeline_policy" {
  role       = aws_iam_role.cwe_code_pipeline_role.name
  policy_arn = aws_iam_policy.cwe_code_pipeline_policy.arn
}

resource "aws_iam_policy" "cloudtrail_cw_logs" {
  count       = var.create_pipeline_trail ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-cloudtrail-cw-logs-policy"
  description = "This policy gives CW Events access trigger the pipeline."
  path        = "/"
  policy      = data.template_file.cloudtrail_cw_logs.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cw_logs" {
  count      = var.create_pipeline_trail ? 1 : 0
  role       = element(concat(aws_iam_role.cloudtrail_cw_logs.*.name, tolist([""])), 0)
  policy_arn = element(concat(aws_iam_policy.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
}
