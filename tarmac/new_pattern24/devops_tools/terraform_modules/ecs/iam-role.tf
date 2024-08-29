# The IAM role(s) that will be used and attached in the ECS services
resource "aws_iam_role" "ecs" {
  name               = "${var.tags["Environment"]}-${var.tags["Application"]}-ecs-iam-role"
  assume_role_policy = var.assume_ecs_role_document
  path               = "/"
  description        = "IAM role for the ${var.tags["Application"]} ECS service."

  tags = var.tags
}
