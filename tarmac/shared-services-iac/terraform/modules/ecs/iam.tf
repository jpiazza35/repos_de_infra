resource "aws_iam_role" "execution" {

  name               = format("%s-task-execution-role", lower(var.cluster["env"]))
  assume_role_policy = data.aws_iam_policy_document.task_assume.json

  tags = merge(
    {
      Name = format("%s-task-execution-role", lower(var.cluster["env"]))
    },
    var.tags,
    {
      Environment = var.cluster["env"]
      App         = var.cluster["app"]
      Resource    = "Managed by Terraform"
      Description = "${var.cluster["app"]} Related Configuration"
      Team        = var.cluster["team"]
    }
  )
}

resource "aws_iam_role_policy" "task_execution" {

  name   = format("%s-task-execution", lower(var.cluster["env"]))
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.task_execution_permissions.json
}

resource "aws_iam_role_policy" "read_repository_credentials" {

  name   = format("%s-read-repository-credentials", lower(var.cluster["env"]))
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.read_repository_credentials.json
}

resource "aws_iam_role_policy" "get_environment_files" {
  count = length(local.get_env_files) > 0 ? 1 : 0

  name   = format("%s-read-repository-credentials", lower(var.cluster["app"]))
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.get_environment_files[count.index].json
}

resource "aws_iam_role" "task" {

  name               = format("%s-task-role", lower(var.cluster["env"]))
  assume_role_policy = data.aws_iam_policy_document.task_assume.json

  tags = merge(
    {
      Name = format("%s-task-role", lower(var.cluster["env"]))
    },
    var.tags,
    {
      Environment = var.cluster["env"]
      App         = var.cluster["app"]
      Resource    = "Managed by Terraform"
      Description = "${var.cluster["app"]} Related Configuration"
      Team        = var.cluster["team"]
    }
  )
}

resource "aws_iam_role_policy" "log_agent" {

  name   = format("%s-log-permissions", lower(var.cluster["env"]))
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_permissions.json
}

resource "aws_iam_role_policy" "read_repository_credentials_task" {

  name   = format("%s-read-repository-credentials", lower(var.cluster["env"]))
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.read_repository_credentials.json
}

resource "aws_iam_role_policy" "ecs_exec_inline_policy" {

  name   = format("%s-ecs-exec-permissions", lower(var.cluster["env"]))
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_ecs_exec_policy.json
}

