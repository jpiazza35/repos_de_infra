module "s3" {
  source                             = "../../modules/s3"
  environment                        = var.config.environment
  s3_bucket_envs                     = var.config.s3_bucket_envs
  tags                               = var.tags
  s3_bucket_name                     = var.config.s3_bucket_name
  s3_bucket_prefix                   = var.config.s3_bucket_prefix
  s3_bucket_acl                      = var.config.s3_bucket_acl
  s3_bucket_configuration_index      = var.config.s3_bucket_configuration_index
  s3_bucket_configuration_error      = var.config.s3_bucket_configuration_error
  s3_bucket_log_name                 = var.config.s3_bucket_log_name
  s3_bucket_block_public_acls        = var.config.s3_bucket_block_public_acls
  s3_bucket_block_public_policy      = var.config.s3_bucket_block_public_policy
  s3_bucket_block_public_restrict    = var.config.s3_bucket_block_public_restrict
  s3_bucket_block_public_ignore_acls = var.config.s3_bucket_block_public_ignore_acls
  load_balancer_bucket_log_name      = var.config.load_balancer_bucket_log_name
  s3_bucket_datalake_name            = var.config.s3_bucket_datalake_name
  s3_bucket_scripts_name             = var.config.s3_bucket_scripts_name
}

module "cloudfront" {
  source                        = "../../modules/cloudfront"
  s3_bucket                     = module.s3.s3_bucket
  s3_bucket_configuration_index = module.s3.s3_bucket_configuration_index
  s3_bucket_log                 = module.s3.s3_bucket_log
  oai_comment                   = var.config.oai_comment
  tags                          = var.tags

  #s3 bucket log variable & distribuion log variables
  #s3 bucket is created anyways TODO: make it optional
  #if distribution_access_logging_enabled    = true -> distribution send access log to s3
  #if if distribution_access_logging_enabled = false -> distribution not send logs
  #Cloudfront setup
  distribution_access_logging_enabled = var.config.distribution_access_logging_enabled
  distribution_enable                 = var.config.distribution_enable
  distribution_ipv6                   = var.config.distribution_ipv6
  distribution_comment                = var.config.distribution_comment
  distribution_default_min_ttl        = var.config.distribution_default_min_ttl
  distribution_default_ttl            = var.config.distribution_default_ttl
  distribution_default_max_ttl        = var.config.distribution_default_max_ttl
  distribution_price_class            = var.config.distribution_price_class
  distribution_restriction_type       = var.config.distribution_restriction_type
  distribution_restriction_locations  = var.config.distribution_restriction_locations
  distribution_viewer_certificate     = var.config.distribution_viewer_certificate
  distribution_acm_certificate        = module.certificates.acm_certificate_arn
  distribution_ssl_support_method     = var.config.distribution_ssl_support_method
  distribution_error_response         = var.config.distribution_error_response
  #if distribution_aliases_enable         = true --> aliases = distribution_aliases + var.distribution_external_aliases
  distribution_aliases_enable   = var.config.distribution_aliases_enable
  distribution_aliases          = var.config.distribution_aliases
  distribution_external_aliases = var.config.distribution_external_aliases
  #Default cache behavior
  distribution_default_cache_allowed_methods  = var.config.distribution_default_cache_allowed_methods
  distribution_default_cached_methods         = var.config.distribution_default_cached_methods
  distribution_default_forwarded_query_string = var.config.distribution_default_forwarded_query_string
  distribution_default_cookies_forward        = var.config.distribution_default_cookies_forward
  distribution_default_viewer_protocol        = var.config.distribution_default_viewer_protocol
  # Cache behavior with precedence 0 | TODO: Make it a list to create many cache ordered
  distribution_ordered_path                   = var.config.distribution_ordered_path
  distribution_ordered_allowed_methods        = var.config.distribution_ordered_allowed_methods
  distribution_ordered_cached_methods         = var.config.distribution_ordered_cached_methods
  distribution_ordered_forwarded_query_string = var.config.distribution_ordered_forwarded_query_string
  distribution_ordered_forwarded_headers      = var.config.distribution_ordered_forwarded_headers
  distribution_ordered_forwarded_cookies      = var.config.distribution_ordered_forwarded_cookies
  distribution_ordered_min_ttl                = var.config.distribution_ordered_min_ttl
  distribution_ordered_ttl                    = var.config.distribution_ordered_ttl
  distribution_ordered_max_ttl                = var.config.distribution_ordered_max_ttl
  distribution_ordered_compress               = var.config.distribution_ordered_compress
  distribution_ordered_viewer_protocol        = var.config.distribution_ordered_viewer_protocol

}

module "iam" {
  source                             = "../../modules/iam"
  s3_bucket_distribution             = module.cloudfront.s3_bucket_distribution
  s3_bucket                          = module.s3.s3_bucket
  s3_bucket_log                      = module.s3.s3_bucket_log
  datalake_bucket                    = module.s3.s3_bucket_datalake
  s3_bucket_scripts                  = module.s3.s3_bucket_scripts
  automation_user_name               = var.config.automation_user_name
  automation_user_path               = var.config.automation_user_path
  instance_secret_manager_name       = var.instance_secret_manager_name
  instance_secret_manager_policy_arn = var.instance_secret_manager_policiy_arn
}

module "vpc" {
  source                                  = "../../modules/vpc"
  environment                             = var.config.environment
  vpc_cidr_block                          = var.config.vpc_cidr_block
  vpc_tags                                = var.vpc_tags
  subnet_availability_zone                = var.config.subnet_availability_zone
  subnet_private_cidr_block               = var.config.subnet_private_cidr_block
  subnet_public_cidr_block                = var.config.subnet_public_cidr_block
  subnet_public_map_public_ip             = var.config.subnet_public_map_public_ip
  route_internet_gateway_destination_cidr = var.config.route_internet_gateway_destination_cidr
  default_vpc_segurity_group_name         = var.config.default_vpc_segurity_group_name
  #instance_network_interface_id           = module.ec2.instance_network_interface_id
  private_dns = var.config.private_dns
  public_dns  = var.config.public_dns
}

# module "ec2" {
#   source                          = "../../modules/ec2"
#   instance_ami                    = var.instance_ami
#   instance_type                   = var.instance_type
#   instance_subnet                 = module.vpc.subnet_private_id
#   instance_tags                   = var.instance_tags
#   tags                            = var.tags
#   instance_volume_size            = var.instance_volume_size
#   instance_volume_az              = var.instance_volume_az
#   instance_security_group         = var.instance_security_group
#   instance_secret_manager_profile = module.iam.instance_secret_manager_profile
# }

module "rds" {
  source                        = "../../modules/rds"
  db_allocated_storage          = var.config.db_allocated_storage
  db_max_allocated_storage      = var.config.db_max_allocated_storage
  db_engine                     = var.config.db_engine
  db_engine_version             = var.config.db_engine_version
  db_instance_class             = var.config.db_instance_class
  db_name                       = var.config.db_name
  db_username                   = var.config.db_username
  db_parameter_group_name       = var.config.db_parameter_group_name
  db_skip_final_snapshot        = var.config.db_skip_final_snapshot
  db_iam_authentication_enabled = var.config.db_iam_authentication_enabled
  db_subnet_group_name          = var.config.db_subnet_group_name
  db_subnet_group_id            = module.vpc.subnet_private_id
  db_root_password_length       = var.config.db_root_password_length
  db_identifier                 = var.config.db_identifier
  vpc_id                        = module.vpc.vpc_id
}

module "redis" {
  source                     = "../../modules/redis"
  environment                = var.config.environment
  redis_name                 = var.config.redis_name
  redis_username             = var.config.redis_username
  tags                       = var.tags
  redis_user_acl_name        = var.config.redis_user_acl_name
  redis_node_type            = var.config.redis_node_type
  redis_num_shards           = var.config.redis_num_shards
  redis_security_group       = module.vpc.redis_security_group_id
  redis_snapshot_retention   = var.config.redis_snapshot_retention
  redis_subnet_group_name    = var.config.redis_subnet_group_name
  redis_vpc_id               = module.vpc.vpc_id
  redis_subnet_ids           = module.vpc.subnet_private_id
  redis_parameter_group_name = var.config.redis_parameter_group_name
  redis_consumer_username    = var.config.redis_consumer_username
}

# module "lb" {
#   source                            = "../../modules/lb"
#   load_balancer_name                = var.load_balancer_name
#   load_balancer_internal            = var.load_balancer_internal
#   load_balancer_type                = var.load_balancer_type
#   load_balancer_deletion_protection = var.load_balancer_deletion_protection
#   load_balancer_log_prefix          = var.load_balancer_log_prefix
#   load_balancer_log_enabled         = var.load_balancer_log_enabled
#   load_balancer_security_group_id   = module.vpc.default_security_group_id
#   load_balancer_subnets             = module.vpc.subnet_public_id
#   load_balancer_log_bucket          = module.s3.load_balancer_bucket_log.bucket
#   tags                              = var.tags
#   # instance                          = module.ec2.ec2_instance
#   vpc_id                            = module.vpc.vpc_id
# }

module "ecs" {
  source                 = "../../modules/ecs"
  config_services        = var.config.services
  environment            = var.config.environment
  vpc_id                 = module.vpc.vpc_id
  vpc_cidr_block         = var.config.vpc_cidr_block
  private_subnets        = module.vpc.subnet_private_id
  public_subnets         = module.vpc.subnet_public_id
  internal_dns_zone_name = module.vpc.internal_dns_zone_name
  internal_dns_id        = module.vpc.internal_dns_zone_id
  public_dns_zone_name   = module.vpc.public_dns_zone_name
  alb_priority           = var.config.alb_priority
  container_definitions  = "${path.root}/../taskdefinitions/generic_task_definition.tpl"
  acm_certificate_arn    = module.certificates.acm_certificate_arn
  exec_command           = var.exec_command
}

module "certificates" {
  source                 = "../../modules/certificates"
  tags                   = var.tags
  environment            = var.config.environment
  public_dns_zone_name   = module.vpc.public_dns_zone_name
  public_dns_zone_id     = module.vpc.public_dns_zone_id
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  lb_dns                 = module.ecs.lb_dns
  lb_zone_id             = module.ecs.lb_zone_id
}
