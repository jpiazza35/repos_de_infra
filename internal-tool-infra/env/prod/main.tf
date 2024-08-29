module "s3" {
  source                             = "../../modules/s3"
  environment                        = var.config.environment
  s3_bucket_envs                     = var.config.s3_bucket_envs
  tags                               = var.tags
  s3_bucket_name                     = var.config.s3_bucket_name
  s3_bucket_prefix                   = var.config.s3_bucket_prefix
  s3_bucket_acl                      = var.config.s3_bucket_acl
  s3_bucket_block_public_acls        = var.config.s3_bucket_block_public_acls
  s3_bucket_block_public_policy      = var.config.s3_bucket_block_public_policy
  s3_bucket_block_public_restrict    = var.config.s3_bucket_block_public_restrict
  s3_bucket_block_public_ignore_acls = var.config.s3_bucket_block_public_ignore_acls
  cloudfront_distribution_arn        = module.cloudfront.cloudfront_distribution_arn
  aws_acc_id                         = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source                   = "../../modules/vpc"
  environment              = var.config.environment
  vpc_cidr_block           = var.config.vpc_cidr_block
  vpc_tags                 = var.vpc_tags
  subnet_availability_zone = var.config.subnet_availability_zone
  subnet_database_cidr_block = [
    cidrsubnet(var.vpc_cidr_block, 8, 6),
    cidrsubnet(var.vpc_cidr_block, 8, 7),
    cidrsubnet(var.vpc_cidr_block, 8, 8),
  ]
  subnet_private_cidr_block = [
    cidrsubnet(var.vpc_cidr_block, 8, 3),
    cidrsubnet(var.vpc_cidr_block, 8, 4),
    cidrsubnet(var.vpc_cidr_block, 8, 5),
  ]
  subnet_public_cidr_block = [
    cidrsubnet(var.vpc_cidr_block, 8, 0),
    cidrsubnet(var.vpc_cidr_block, 8, 1),
    cidrsubnet(var.vpc_cidr_block, 8, 2),
  ]
  subnet_public_map_public_ip             = var.config.subnet_public_map_public_ip
  route_internet_gateway_destination_cidr = var.config.route_internet_gateway_destination_cidr
  default_vpc_segurity_group_name         = var.config.default_vpc_segurity_group_name
  #private_dns                             = var.config.private_dns
  #public_dns                              = var.config.public_dns
}

module "aurora" {
  source                             = "../../modules/aurora"
  db_cluster_identifier              = var.config.db_cluster_identifier
  db_cluster_engine                  = var.config.db_cluster_engine
  db_cluster_engine_version          = var.config.db_cluster_engine_version
  db_cluster_availability_zones      = var.config.db_cluster_availability_zones
  db_cluster_database_name           = var.config.db_cluster_database_name
  db_cluster_master_username         = var.config.db_cluster_master_username
  db_cluster_instance_class          = var.config.db_cluster_instance_class
  db_cluster_backup_retention_period = var.config.db_cluster_backup_retention_period
  db_cluster_storage_encrypted       = var.config.db_cluster_storage_encrypted
  db_cluster_subnet_group_name       = var.config.db_cluster_subnet_group_name
  db_cluster_subnet_database_id      = module.vpc.subnet_database_id
  db_cluster_tags                    = var.config.db_cluster_tags
  db_cluster_vpc_id                  = module.vpc.vpc_id
  db_cluster_subnet_private_cidr     = module.vpc.subnet_private_cidr
  db_cluster_apply_immediately       = var.config.db_cluster_apply_immediately
  db_vpn_security_group_id           = ""
  private_subnets                    = module.vpc.subnet_private_cidr
  environment                        = var.config.environment
  aws_acc_id                         = data.aws_caller_identity.current.account_id
  db_cluster_kms_key                 = var.config.db_cluster_kms_key
  db_cluster_identifier_name         = var.db_cluster_identifier_name
}

module "ecs" {
  source          = "../../modules/ecs"
  config_services = var.config.services
  environment     = var.config.environment
  vpc_id          = module.vpc.vpc_id
  vpc_cidr_block  = var.config.vpc_cidr_block
  private_subnets = module.vpc.subnet_private_id
  public_subnets  = module.vpc.subnet_public_id
  #public_dns_zone_name   = module.vpc.public_dns_zone_name
  alb_priority = var.config.alb_priority
  #internal_dns_zone_name = module.vpc.internal_dns_zone_name
  #internal_dns_id        = module.vpc.internal_dns_zone_id
  container_definitions = "${path.root}/../taskdefinitions/generic_task_definition.tpl"
  acm_certificate_arn   = module.cloudfront.aws_acm_certificate_arn
  exec_command          = var.exec_command
  region                = var.region
  aws_acc_id            = data.aws_caller_identity.current.account_id
  aws_acc_id_arn        = "arn:aws:iam::671035760640:role/AllowProdCrossAcountRole"
}

# module "ec2" {
#   source          = "../../modules/ec2"
#   vpc_id          = module.vpc.vpc_id
#   vpc_cidr_block  = var.config.vpc_cidr_block
#   public_subnets  = module.vpc.subnet_public_id
#   key_pair        = var.config.key_pair
#   instance_ami    = var.config.instance_ami
#   instance_type   = var.config.instance_type
#   tarmac_mkd_office_static_ip = var.config.tarmac_mkd_office_static_ip
#   tags                        = var.config.tags

# #   # #public_dns_zone_name   = module.vpc.public_dns_zone_name
# #   # alb_priority = var.config.alb_priority
# #   # #internal_dns_zone_name = module.vpc.internal_dns_zone_name
# #   # #internal_dns_id        = module.vpc.internal_dns_zone_id
# #   # container_definitions = "${path.root}/../taskdefinitions/generic_task_definition.tpl"
# #   # acm_certificate_arn    = module.cloudfront.aws_acm_certificate_arn
# #   # exec_command = var.exec_command
# }

module "cloudfront" {
  source                         = "../../modules/cloudfront"
  cloudfront_default_root_object = var.config.cloudfront_default_root_object
  cloudfront_error_code          = var.config.cloudfront_error_code
  cloudfront_response_code       = var.config.cloudfront_response_code
  cloudfront_response_page_path  = var.config.cloudfront_response_page_path
  cloudfront_origin_id           = var.config.cloudfront_origin_id
  cloudfront_origin_domain_name  = var.config.cloudfront_origin_id
  lb_dns                         = module.ecs.lb_dns
  lb_zone_id                     = module.ecs.lb_zone_id
  region                         = var.region
  environment                    = var.config.environment
  web_acl_arn                    = module.waf.wafv2_web_acl_cloudfront_arn
  aws_acc_id_arn                 = "arn:aws:iam::671035760640:role/AllowProdCrossAcountRole"
}

module "oidc" {
  source                        = "../../modules/oidc"
  oidc_environment              = var.config.environment
  oidc_provider_name            = var.config.oidc.providerName
  oidc_provider_organization    = var.config.oidc.organization
  oidc_provider_thumbprint_list = var.config.oidc.thumbprintList
  oidc_provider_url             = var.config.oidc.providerUrl
  oidc_provider_extra_tags      = var.config.tags
  oidc_ecr_backend_name         = var.config.oidc.ecrBackendName
}

module "cognito" {
  source     = "../../modules/cognito"
  properties = var.config.cognito
  tags       = var.config.tags
}

module "waf" {
  source                      = "../../modules/waf"
  lb_arn                      = module.ecs.lb_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  tags                        = var.tags
  properties                  = var.config.waf
}

module "lambda" {
  source             = "../../modules/lambda"
  lambda_environment = var.config.environment
  lambda_project     = "internaltool"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  ecs_metrics = {
    "CPUUtilization" = {
      alarm_name          = "EcsTaskExecutionAlarm-${var.environment}"
      alarm_description   = "ECS Task Execution Alarm"
      cluster_name        = "dev-default-ecs"
      service_name        = "internaltool"
      namespace           = "AWS/ECS"
      statistic           = "SampleCount"
      period              = "60"
      evaluation_periods  = "2"
      datapoints_to_alarm = "2"
      threshold           = "2"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      missing_data        = "notBreaching"
    }
  }
  sns_topic_notifications = [module.lambda.sns_topic_arn]
  environment             = var.config.environment
  region                  = var.region
  dashboard_body          = file("${path.module}/dashboard_body.json")
}

module "cloudtrail" {
  source = "../../modules/cloudtrail"
  tags   = var.config.tags
}

module "iam" {
  source                                    = "../../modules/iam"
  properties                                = var.config
  iam_minimum_password_length               = var.config.iam_minimum_password_length
  iam_password_require_lowercase_characters = var.config.iam_password_require_lowercase_characters
  iam_password_require_uppercase_characters = var.config.iam_password_require_uppercase_characters
  iam_password_require_numbers              = var.config.iam_password_require_numbers
  iam_password_require_symbols              = var.config.iam_password_require_symbols
  iam_max_password_age                      = var.config.iam_max_password_age
  iam_allow_users_to_change_password        = var.config.iam_allow_users_to_change_password
  iam_password_reuse_prevention             = var.config.iam_password_reuse_prevention
}
