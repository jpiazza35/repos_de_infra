data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = "${var.cluster_name}-worker-node-eks-node-group"
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  depends_on = [module.eks]
}