resource "aws_iam_role" "execution" {
  count              = local.default
  name               = format("%s-task-execution-role", lower(var.env))
  assume_role_policy = data.aws_iam_policy_document.task_assume[count.index].json

  tags = var.tags
}

resource "aws_iam_role_policy" "task_execution" {
  count  = local.default
  name   = format("%s-task-execution", lower(var.env))
  role   = aws_iam_role.execution[count.index].id
  policy = data.aws_iam_policy_document.task_execution_permissions[count.index].json
}

resource "aws_iam_role_policy" "read_repository_credentials" {
  count = var.create_repository_credentials_iam_policy && terraform.workspace == "sharedservices" ? 1 : 0

  name   = format("%s-read-repository-credentials", lower(var.env))
  role   = aws_iam_role.execution[count.index].id
  policy = data.aws_iam_policy_document.read_repository_credentials[count.index].json
}

resource "aws_iam_role_policy" "get_environment_files" {
  count = length(var.task_container_environment_files) != 0 && terraform.workspace == "sharedservices" ? 1 : 0

  name   = format("%s-read-repository-credentials", lower(var.env))
  role   = aws_iam_role.execution[count.index].id
  policy = data.aws_iam_policy_document.get_environment_files[count.index].json
}

resource "aws_iam_role" "task" {
  count              = local.default
  name               = format("%s-task-role", lower(var.env))
  assume_role_policy = data.aws_iam_policy_document.task_assume[count.index].json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess",
  ]

  tags = var.tags

}

resource "aws_iam_role_policy" "log_agent" {
  count  = local.default
  name   = format("%s-log-permissions", lower(var.env))
  role   = aws_iam_role.task[count.index].id
  policy = data.aws_iam_policy_document.task_permissions[count.index].json
}

resource "aws_iam_role_policy" "ecs_exec_inline_policy" {
  count = var.enable_execute_command && terraform.workspace == "sharedservices" ? 1 : 0

  name   = format("%s-ecs-exec-permissions", lower(var.env))
  role   = aws_iam_role.task[count.index].id
  policy = data.aws_iam_policy_document.task_ecs_exec_policy[count.index].json
}

## Sonatype S3 permissions

resource "aws_iam_role" "sonatype_execution" {
  count              = local.default
  name               = format("%s-sonatype-task-execution-role", lower(var.env))
  assume_role_policy = data.aws_iam_policy_document.task_assume[count.index].json

  tags = var.tags
}

resource "aws_iam_role_policy" "sonatype_task_execution" {
  count  = local.default
  name   = format("%s-sonatype-task-execution", lower(var.env))
  role   = aws_iam_role.sonatype_execution[count.index].id
  policy = data.aws_iam_policy_document.sonatype_task_execution_permissions[count.index].json
}

resource "aws_iam_role" "sonatype_task" {
  count              = local.default
  name               = format("%s-sonatype-task-role", lower(var.env))
  assume_role_policy = data.aws_iam_policy_document.task_assume[count.index].json

  tags = var.tags
}

resource "aws_iam_role_policy" "sonatype_log_agent" {
  count  = local.default
  name   = format("%s-sonatype-log-permissions", lower(var.env))
  role   = aws_iam_role.sonatype_task[count.index].id
  policy = data.aws_iam_policy_document.task_permissions[count.index].json
}

resource "aws_iam_role_policy" "sonatype_ecs_exec_inline_policy" {
  count = var.enable_execute_command && terraform.workspace == "sharedservices" ? 1 : 0

  name   = format("%s-sonatype-ecs-exec-permissions", lower(var.env))
  role   = aws_iam_role.sonatype_task[count.index].id
  policy = data.aws_iam_policy_document.task_ecs_exec_policy[count.index].json
}

resource "aws_iam_role_policy" "sonatype_s3_task" {
  count  = local.default
  name   = format("%s-ecs-s3-permissions", lower(var.env))
  role   = aws_iam_role.sonatype_task[count.index].id
  policy = data.aws_iam_policy_document.s3_task_policy[count.index].json
}
