resource "aws_iam_instance_profile" "ec2" {
  count = local.default
  name  = format("instance-profile-%s-%s", var.app, var.env)
  role  = aws_iam_role.ec2_instance_role[count.index].name
}

resource "aws_iam_role" "ec2_instance_role" {
  count              = local.default
  name               = "instance-role-${var.app}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_attachment" {
  count      = local.default
  role       = aws_iam_role.ec2_instance_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  count      = local.default == 1 && var.additional_iam_policy_arn != null ? 1 : 0
  role       = aws_iam_role.ec2_instance_role[count.index].name
  policy_arn = var.additional_iam_policy_arn
}
