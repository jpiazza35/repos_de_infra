resource "aws_iam_role" "ecs-default" {
  name               = "ecs-task-execution-for-ecs-fargate"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  path               = "/"
  description        = "IAM role for ECS"
  tags               = merge(var.tags, tomap({ "Name" = "iam-role-ecs-services-${lower(var.tags["act"])}" }))
}
resource "aws_iam_policy" "ecs-default" {
  name   = aws_iam_role.ecs-default.name
  policy = data.aws_iam_policy.ecs_task_execution.policy
}
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.ecs-default.name
  policy_arn = aws_iam_policy.ecs-default.arn
}