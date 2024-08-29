data "aws_caller_identity" "current" {}

# data "aws_vpc" "main" {
#   tags = {
#     Name = "vpc-${var.tags["env"]}-${var.tags["vpc"]}"
#   }
# }

# data "aws_availability_zones" "available" {}

# data "aws_subnet_ids" "public" {
#   vpc_id = data.aws_vpc.main.id

#   tags = {
#     Name = "*public*"
#   }
# }

# data "aws_ecs_cluster" "ecs-cluster" {
#   cluster_name = "ECS_CLUSTER_NAME"
# }

# data "aws_iam_role" "ecs-role" {
#   name = "IAM_ROLE_FOR_ECS"
# }