resource "aws_iam_role" "cert_manager" {
  name               = "${var.env}-${var.product}-${var.cert_manager_release_name}"
  assume_role_policy = var.cert_manager_role_trust_policy
  path               = "/"
  description        = "IAM role used in k8s ${var.cert_manager_release_name} to manage certificates."
}

resource "aws_iam_policy" "cert_manager" {
  name        = "${var.env}-${var.product}-${var.cert_manager_release_name}"
  path        = "/"
  description = "IAM policy allowing needed access for the ${var.cert_manager_release_name} IAM role."
  policy      = var.cert_manager_role_access_policy
}

resource "aws_iam_role_policy_attachment" "cert_manager" {
  role       = aws_iam_role.cert_manager.name
  policy_arn = aws_iam_policy.cert_manager.arn
}
