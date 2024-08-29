module "ecs" {
  source                          = "./modules/tools_ecs"
  app                             = "phpipam"
  env                             = var.env
  acm_arn                         = module.acm.acm
  capacity_provider_strategy      = var.capacity_provider_strategy
  vpc_id                          = data.aws_vpc.vpc[0].id
  vpc_cidr                        = data.aws_vpc.vpc[0].cidr_block
  public_subnet_ids               = data.aws_subnets.public[0].ids
  private_subnet_ids              = data.aws_subnets.all[0].ids
  desired_count                   = 1
  task_container_image            = var.task_container_image
  task_definition_cpu             = var.task_definition_cpu
  task_definition_memory          = var.task_definition_memory
  task_container_memory           = 512
  task_container_cpu              = var.task_container_cpu
  task_container_port             = var.task_container_port
  task_container_assign_public_ip = var.task_container_assign_public_ip

  target_groups = var.target_groups

  health_check = var.health_check

  enable_deployment_circuit_breaker          = var.enable_deployment_circuit_breaker
  enable_deployment_circuit_breaker_rollback = var.enable_deployment_circuit_breaker
  load_balanced                              = var.load_balanced
  region                                     = var.region

  ### PHPIPAM 
  mysql_port   = 3306
  rds_endpoint = module.rds.endpoint

  ## Sonatype Artifactory
  sonatype_app                             = "sonatype_artifactory"
  sonatype_task_container_image            = var.sonatype_task_container_image
  sonatype_task_definition_cpu             = var.sonatype_task_definition_cpu
  sonatype_task_definition_memory          = var.sonatype_task_definition_memory
  sonatype_task_container_memory           = var.sonatype_task_container_memory
  sonatype_task_container_cpu              = var.sonatype_task_container_cpu
  sonatype_task_container_port             = var.sonatype_task_container_port
  sonatype_task_container_assign_public_ip = var.sonatype_task_container_assign_public_ip

  sonatype_target_groups = var.sonatype_target_groups
  sonatype_health_check  = var.sonatype_health_check

  sonatype_acm_arn             = module.sonatype_acm.acm
  sonatype_efs_id              = aws_efs_file_system.ecs_efs_sonatype.id
  sonatype_efs_access_point_id = aws_efs_access_point.sonatype_ap.id


  ## Incident Bot
  # incident_bot_app                             = "incident_bot"
  # incident_bot_task_container_image            = var.incident_bot_task_container_image
  # incident_bot_task_definition_cpu             = var.incident_bot_task_definition_cpu
  # incident_bot_task_definition_memory          = var.incident_bot_task_definition_memory
  # incident_bot_task_container_memory           = var.incident_bot_task_container_memory
  # incident_bot_task_container_cpu              = var.incident_bot_task_container_cpu
  # incident_bot_task_container_port             = var.incident_bot_task_container_port
  # incident_bot_task_container_assign_public_ip = var.incident_bot_task_container_assign_public_ip

  # incident_bot_target_groups = var.incident_bot_target_groups
  # incident_bot_health_check  = var.incident_bot_health_check

  # incident_bot_acm_arn             = module.incident_bot_acm.acm
  # incident_bot_efs_id              = aws_efs_file_system.ecs_efs_incident_bot.id
  # incident_bot_efs_access_point_id = aws_efs_access_point.incident_bot_ap.id


  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "ecs"
      Resource       = "Managed by Terraform"
      Description    = "ECS Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

}
