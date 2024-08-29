# data "aws_vpc" "current" {
#   id = var.vpc_id
# }

# data "aws_subnet_ids" "private" {
#   vpc_id = data.aws_vpc.current.id

#   tags = {
#     Name = "*private*"
#   }
# }

# data "aws_subnet" "private" {
#   count = length(data.aws_subnet_ids.private.ids)
#   id    = tolist(data.aws_subnet_ids.private.ids)[count.index]
# }

# data "aws_security_group" "ecs-service-sg" {
#   name = "sgrp-ecs-service-${var.tags["env"]}"
# }