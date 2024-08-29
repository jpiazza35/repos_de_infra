resource "aws_iam_role" "config_iam_role" {
  name               = "awsconfig-iam-role"
  tags               = var.tags
  assume_role_policy = templatefile("${path.module}/policies/aws_config_role_policy.json", {})
}

resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  role       = aws_iam_role.config_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "read_only_policy_attach" {
  role       = aws_iam_role.config_iam_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
}
