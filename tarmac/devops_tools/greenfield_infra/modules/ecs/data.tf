data "aws_caller_identity" "current" {}

data "aws_vpc" "current" {
  id = var.vpc_id
}

# data "aws_subnet_ids" "data" {
#   vpc_id = data.aws_vpc.current.id

#   tags = {
#     Name = "*data*"
#   }
# }

# data "aws_subnet" "data" {
#   count = length(data.aws_subnet_ids.data.ids)
#   id    = data.aws_subnet_ids.data.ids[count.index]
# }

# data "aws_subnet_ids" "private" {
#   vpc_id = data.aws_vpc.current.id

#   tags = {
#     Name = "*private*"
#   }
# }

# data "aws_subnet_ids" "public" {
#   vpc_id = data.aws_vpc.current.id

#   tags = {
#     Name = "*public*"
#   }
# }

# data "aws_subnet" "private" {
#   count = length(data.aws_subnet_ids.private.ids)
#   id    = tolist(data.aws_subnet_ids.private.ids)[count.index]
# }

# data "aws_subnet" "public" {
#   count = length(data.aws_subnet_ids.public.ids)
#   id    = tolist(data.aws_subnet_ids.public.ids)[count.index]
# }

# data "aws_vpc_endpoint" "s3" {
#   vpc_id       = data.aws_vpc.current.id
#   service_name = "com.amazonaws.${var.region}.s3"
# }

# data "aws_route53_zone" "private" {
#   name         = var.private_dns
#   vpc_id       = var.vpc_id
#   private_zone = true
# }

# data "aws_route53_zone" "public" {
#   name         = var.public_dns
#   private_zone = false
# }

# data "aws_acm_certificate" "selected" {
#   domain      = "*.${var.public_dns}"
#   most_recent = true
# }

# data "aws_ecs_cluster" "current" {
#   cluster_name = "AWS_ECS_CLUSTER"
# }

# data "aws_iam_role" "current" {
#   name = "ecs-iam-role-${var.name}"
# }

# data "aws_lb" "ecs-lb" {
#   name = "alb-ecs-services-${var.tags["act"]}" # already exists in AWS, it is just fetched with its name
# }

# data "aws_security_group" "sg-alb-ecs" {
#   name = "sgrp-alb-ecs-services-${var.tags["act"]}" # already exists in AWS, it is just fetched with its name
# }

# data "aws_lb" "i-ecs-nlb" {
#   name = "i-nlb-ecs-services-${var.tags["act"]}" # already exists in AWS, it is just fetched with its name
# }

# data "aws_security_group" "i-sg-alb-ecs" {
#   name = "sgrp-i-alb-ecs-services-${var.tags["act"]}" # already exists in AWS, it is just fetched with its name
# }

# data "aws_ecs_task_definition" "ecs-task-def" {
#   task_definition = aws_ecs_task_definition.ecs-task-def.family
# }

# data "aws_security_group" "bcx-api" {
#   name = "sgrp-ecs-service-bcx-api-${var.tags["env"]}" # already exists in AWS, it is just fetched with its name
# }

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# data "aws_security_group" "sg-rds" {
#   name = "sec-rds-${var.tags["env"]}-${var.tags["vpc"]}-${var.tags["service"]}"
# }