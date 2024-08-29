data "aws_caller_identity" "current" {
}

data "aws_vpc" "current" {
  id = var.vpc_id
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.current.id

  tags = {
    Name = "*data*"
  }
}

data "aws_subnet" "data" {
  count = length(data.aws_subnet_ids.data.ids)
  id    = tolist(data.aws_subnet_ids.data.ids)[count.index]
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.current.id

  tags = {
    Name = "*private*"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.current.id

  tags = {
    Name = "*public*"
  }
}

data "aws_subnet" "private" {
  count = length(data.aws_subnet_ids.private.ids)
  id    = tolist(data.aws_subnet_ids.private.ids)[count.index]
}

data "aws_subnet" "public" {
  count = length(data.aws_subnet_ids.public.ids)
  id    = tolist(data.aws_subnet_ids.public.ids)[count.index]
}
data "aws_ecs_cluster" "current" {
  cluster_name = "${var.tags["act"]}-fargate"
}

# use the role with appropriate permissions for your ecs scheduled task
data "aws_iam_role" "current" {
  name = "__________________"
}
data "aws_ecs_task_definition" "ecs-task-def" {
  task_definition = aws_ecs_task_definition.ecs-task-def.family
}

