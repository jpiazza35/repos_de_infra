
resource "aws_ecs_task_definition" "ecs-task-def" {
  family                   = "${var.name}-${var.tags["env"]}"
  task_role_arn            = data.aws_iam_role.current.arn
  execution_role_arn       = data.aws_iam_role.current.arn
  container_definitions    = var.container_definitions
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"
}


