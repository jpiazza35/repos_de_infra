resource "aws_iam_role" "config_iam_role" {
  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-iam-role"
  tags               = var.tags
  assume_role_policy = data.template_file.aws_config_role.rendered
}

resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  role       = aws_iam_role.config_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy_attachment" "read_only_policy_attach" {
  role       = aws_iam_role.config_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role" "ssm_remediation_iam_role" {
  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-ssm-remediation-role"
  tags               = var.tags
  assume_role_policy = data.template_file.ssm_remediation_iam_role.rendered
}

resource "aws_iam_role_policy_attachment" "ssm_automation_policy_attach" {
  role       = aws_iam_role.ssm_remediation_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

resource "aws_iam_policy" "ssm_remediation_policy" {
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-ssm-remediation-policy"
  description = "This policy gives the SSM remediation role its permissions."
  path        = "/"
  policy      = data.template_file.ssm_remediation_iam_permissions.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_remediation_policy_attach" {
  role       = aws_iam_role.ssm_remediation_iam_role.name
  policy_arn = aws_iam_policy.ssm_remediation_policy.arn
}