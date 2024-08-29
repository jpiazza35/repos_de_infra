provider "aws" {
  profile = var.profile
  region  = var.region
}

module "prod-fargate" {
  source                = "../../module-ecs"
  name                  = "____________"
  container_name        = "____________"
  container_port        = "_____"
  cluster               = data.aws_ecs_cluster.ecs-cluster.arn
  vpc_id                = data.aws_vpc.main.id
  container_definitions = data.template_file.default.rendered
  public_dns            = "____________"
  private_dns           = "____________"
  tags = merge(
    var.tags,
    {
      "env" = "prod"
    },
  )
  region = var.region

  s3_backend_bucket_name = "____________" # bucket for tf state files

  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller_type         = "ECS"
  assign_public_ip                   = false # set to true if you need it
  health_check_grace_period_seconds  = 10
  ingress_cidr_blocks                = ["0.0.0.0/0"]
  cpu                                = 512
  memory                             = 1024
  requires_compatibilities           = ["FARGATE"]
  enabled                            = true
}

data "template_file" "default" {
  template = file("${path.module}/container-definitions.json")

  vars = {
    container_name = "____________"
    ecr_name       = "____________"
    ecr_url        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }
}

