data "aws_caller_identity" "current" {
}

data "aws_vpc" "main" {
  tags = {
    Name = "vpc-${var.tags["act"]}-main"
  }
}

data "aws_ecs_cluster" "ecs-cluster" {
  cluster_name = "________________"
}

