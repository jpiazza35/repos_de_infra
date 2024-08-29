resource "aws_iam_policy" "cloudtrail_cw_logs" {
  count       = var.send_cloudtrail_logs ? 1 : 0
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-cloudtrail-cw-logs-policy"
  description = "This policy gives CW Events access trigger the pipeline."
  path        = "/"
  policy      = data.template_file.cloudtrail_cw_logs.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cw_logs" {
  count      = var.send_cloudtrail_logs ? 1 : 0
  role       = element(concat(aws_iam_role.cloudtrail_cw_logs.*.name, tolist([""])), 0)
  policy_arn = element(concat(aws_iam_policy.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
}