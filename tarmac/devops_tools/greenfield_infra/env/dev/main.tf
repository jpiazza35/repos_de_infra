module "vpc" {
  source             = "../../modules/vpc"
  region             = var.region
  project            = var.projectname
  cidr_block         = var.cidr_block
  private_dns        = "${var.projectname}.phz"
  public_dns         = var.rootdomain
  nat                = "true"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]

  public_subnets = [
    cidrsubnet(var.cidr_block, 6, 0),
    cidrsubnet(var.cidr_block, 6, 1),
    cidrsubnet(var.cidr_block, 6, 2),
  ]

  private_subnets = [
    cidrsubnet(var.cidr_block, 6, 3),
    cidrsubnet(var.cidr_block, 6, 4),
    cidrsubnet(var.cidr_block, 6, 5),
  ]

  tags = var.tags
}

module "fargate" {
  source         = "../../modules/ecs"
  name           = var.projectname
  container_name = join("-", [var.projectname, var.env])
  container_port = "8080"
  #cluster                   = aws_ecs_cluster.ecs-fargate.arn
  subnets               = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  container_definitions = data.template_file.default-dev.rendered
  public_dns            = var.rootdomain
  private_dns           = var.rootdomain
  tags                  = merge(var.tags, tomap({ "env" = "dev" }))
  region                = var.region

  private_r53 = module.vpc.r53_private
  public_r53  = module.vpc.r53_public

  s3_backend_bucket_name = "TF_STATE_S3_BUCKET" # if needed, for pulling remote state resources

  cidr_blocks           = module.vpc.cidr_blocks
  rds_security_group_id = module.rds.sg-rds

  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller_type         = "ECS"
  assign_public_ip                   = true
  health_check_grace_period_seconds  = 10
  ingress_cidr_blocks                = ["0.0.0.0/0"]
  cpu                                = 512
  memory                             = 1024
  requires_compatibilities           = ["FARGATE"]
  enabled                            = true

  create_ecs_task_execution_role = false
  # ecs_task_execution_role_arn        = aws_iam_role.ecs-default.arn
}

data "template_file" "default-dev" {
  template = file("${path.module}/container-definitions-dev.json")

  vars = {
    container_name = "${var.projectname}-dev"
    ecr_name       = var.projectname
    ecr_url        = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    container_port = "8080"
  }
}

module "rds" {
  source                = "../../modules/rds"
  name                  = var.name
  rds_password          = var.rds_password
  db_instance_class     = "db.t2.micro"
  subnet_ids            = module.vpc.private_subnet_ids
  tags                  = merge(var.tags, tomap({ "env" = "dev" }))
  vpc_id                = module.vpc.vpc_id
  ecs_security_group_id = module.fargate.security_group_id
}


