# The IAM role that will be assumed by Product ECS IAM roles to fetch images from ECR in Shared Services
resource "aws_iam_role" "ecr" {
  name               = "${var.tags["Environment"]}-ecr-readonly-role"
  assume_role_policy = var.allow_assume_role_productou_accounts
  path               = "/"
  description        = "IAM role that allows ECR access to Product ECS IAM roles."

  tags = var.tags
}

resource "aws_iam_policy" "ecr" {
  name        = "${var.tags["Environment"]}-ecr-readonly-policy"
  description = "This policy allows ECR readonly permissions to the ${var.tags["Environment"]}-ecr-readonly-role."
  path        = "/"
  policy      = data.template_file.ecr_readonly.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ecr.name
  policy_arn = aws_iam_policy.ecr.arn
}

# The IAM role that will be assumed by Product RundeckTechUser(s) to push and pull docker images from ECR repos
resource "aws_iam_role" "rundeck_ecr" {
  name               = "${var.tags["Environment"]}-rundeck-ecr-role"
  assume_role_policy = var.allow_assume_role_productou_accounts
  path               = "/"
  description        = "IAM role that allows ECR access to Product RundeckTechUser(s)."

  tags = var.tags
}

resource "aws_iam_policy" "rundeck_ecr" {
  name        = "${var.tags["Environment"]}-rundeck-ecr-policy"
  description = "This policy allows ECR access to the ${var.tags["Environment"]}-rundeck-ecr-role."
  path        = "/"
  policy      = data.template_file.rundeck_ecr.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rundeck_ecr" {
  role       = aws_iam_role.rundeck_ecr.name
  policy_arn = aws_iam_policy.rundeck_ecr.arn
}
