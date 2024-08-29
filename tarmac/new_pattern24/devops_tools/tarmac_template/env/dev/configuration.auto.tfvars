config = {

  ## Provider variables
  region  = "us-east-1"
  profile = "default"


  ## Environment variables
  tags = { "Environment" : "dev" }

  environment = "dev"

  public_dns  = "dev.example.com"
  private_dns = "example.internal"

  ## s3 Bucket variables
  s3_bucket_envs                     = { "Bucket" : "Frontend" }
  s3_bucket_name                     = "default-cloudfront-dev"
  s3_bucket_prefix                   = ""
  s3_bucket_acl                      = "private"
  s3_bucket_configuration_index      = "index.html"
  s3_bucket_configuration_error      = "index.html"
  s3_bucket_block_public_acls        = true
  s3_bucket_block_public_policy      = true
  s3_bucket_block_public_restrict    = true
  s3_bucket_block_public_ignore_acls = true
  s3_bucket_datalake_name            = "default-datalake-dev"
  s3_bucket_scripts_name             = "default-scripts-dev"



  ## s3 Routing rules
  #if s3Bucket_routing_rule_enable     = true --> routing rules are configured
  s3_bucket_routing_rule_enable     = false
  s3_bucket_key_prefix_equals       = ""
  s3_bucket_replace_key_prefix_with = ""

  #s3 bucket log variable & distribuion log variables
  #s3 bucket is created anyways TODO: make it optional
  #if distribution_access_logging_enabled = true -> distribution send access log to s3
  #if if distribution_access_logging_enabled = false -> distribution not send logs
  s3_bucket_log_name                      = "default-frontend-dev-logging"
  distribution_access_logging_enabled     = false
  distribution_access_log_include_cookies = false
  distribution_access_log_prefix          = ""


  ## CloudFront aliases#if distribution_aliases_enable = true --> aliases= distribution_aliases + var.distribution_external_aliases
  distribution_aliases_enable   = true
  distribution_aliases          = ["app.dev.example.com", "api.dev.example.com"]
  distribution_external_aliases = [""]
  ## CloudFront Distribution variables
  oai_comment                        = "Access to dev-website s3 content"
  distribution_enable                = true
  distribution_ipv6                  = true
  distribution_comment               = "Cloudfront distribution dev website"
  distribution_default_min_ttl       = 0
  distribution_default_ttl           = 3600
  distribution_default_max_ttl       = 86400
  distribution_price_class           = "PriceClass_100"
  distribution_restriction_type      = "none" #"whitelist"
  distribution_restriction_locations = [""]   #["UY","US"]
  distribution_viewer_certificate    = true
  distribution_ssl_support_method    = "sni-only"
  distribution_error_response = [
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 400,
      "response_code"         = 400,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 403,
      "response_code"         = 200,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 404,
      "response_code"         = 404,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 405,
      "response_code"         = 405,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 414,
      "response_code"         = 414,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 416,
      "response_code"         = 416,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 500,
      "response_code"         = 500,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 501,
      "response_code"         = 501,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 502,
      "response_code"         = 502,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 503,
      "response_code"         = 503,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 10,
      "error_code"            = 504,
      "response_code"         = 504,
      "response_page_path"    = "/index.html",
    }
  ]

  ### Default variables
  distribution_default_cache_allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  distribution_default_cached_methods         = ["GET", "HEAD"]
  distribution_default_forwarded_query_string = false
  distribution_default_cookies_forward        = "none"
  distribution_default_viewer_protocol        = "allow-all"

  ### Ordered variables
  distribution_ordered_path                   = "/*"
  distribution_ordered_allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  distribution_ordered_cached_methods         = ["GET", "HEAD", "OPTIONS"]
  distribution_ordered_forwarded_query_string = false
  distribution_ordered_forwarded_headers      = ["Origin"]
  distribution_ordered_forwarded_cookies      = "none"
  distribution_ordered_min_ttl                = 0
  distribution_ordered_ttl                    = 86400
  distribution_ordered_max_ttl                = 31536000
  distribution_ordered_compress               = true
  distribution_ordered_viewer_protocol        = "redirect-to-https"

  ## IAM variables
  automation_user_name     = "dev-automation"
  automation_user_path     = "/"
  load_balancer_account_id = "127311923021" #Generic AWS Account depending on the region

  ## VPC variables
  vpc_cidr_block                          = "10.0.0.0/16"
  vpc_tags                                = { Name = "main" }
  subnet_availability_zone                = ["us-east-1a", "us-east-1b"]
  subnet_private_cidr_block               = ["10.0.2.0/24", "10.0.3.0/24"]
  subnet_public_cidr_block                = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_public_map_public_ip             = true
  route_internet_gateway_destination_cidr = "0.0.0.0/0"
  default_vpc_segurity_group_name         = "default-vpc-sg"

  ## EC2 variables
  instance_ami         = "ami-0c02fb55956c7d316"
  instance_type        = "t2.medium"
  instance_tags        = { "Name" : "Dev Instance" }
  instance_volume_size = 10
  instance_volume_az   = "us-east-1d" #could be a data resource obtain from the ec2 instance az

  ## RDS variables

  db_allocated_storage          = 10
  db_max_allocated_storage      = 20
  db_engine                     = "postgres"
  db_engine_version             = "14.3"
  db_instance_class             = "db.t3.micro"
  db_name                       = "psqldb"
  db_username                   = "postgres"
  db_parameter_group_name       = "default.postgres14"
  db_skip_final_snapshot        = true
  db_iam_authentication_enabled = true
  db_subnet_group_name          = "main"
  db_root_password_length       = 16
  db_identifier                 = "default-db-dev"

  ## Redis variables
  redis_name                 = "default-redis-dev"
  redis_username             = "redis"
  redis_user_acl_name        = "redis-users-acl"
  redis_node_type            = "db.t4g.small"
  redis_num_shards           = 1
  redis_snapshot_retention   = 7
  redis_subnet_group_name    = "redis-subnet-group"
  redis_parameter_group_name = "default.memorydb-redis6"
  redis_consumer_username    = "redis-consumer"

  ## Load balancer variables
  load_balancer_name                = "application-load-balancer"
  load_balancer_internal            = false
  load_balancer_type                = "application"
  load_balancer_deletion_protection = false
  load_balancer_log_prefix          = "lb-log"
  load_balancer_log_enabled         = true
  load_balancer_bucket_log_name     = "default-load-balancer-log-dev"
  alb_priority                      = 99

  ## ECS variables
  # ecs_cluster_name = "default-ecs-dev"
  exec_command = false

  services = {
    ##### SERVICE TEMPLATE #####
    # backend = {
    # type                = ""          # value can be public/private/worker
    # service             = ""          # short service name (will be used as subdomain for the internal dns
    # name                = ""          # named used in the resource naming
    # cpu                 = 256         # cpu size of each task 256 = 0.25 cores
    # memory              = 512         # memory size of each task in MB
    # target_group_prefix = ""          # can't be longer than 6 characters
    # healthcheck_path = ""             # health check path. This is not needed when type = worker

    #   taskDefinitionValues = {
    # image          = ""               # container image arn (can be copied from ECR)
    # container_name = ""
    # container_port = 8000             # Preferred port is 8000
    # host_port      = 8000
    # awslogs-region = "us-east-1"
    # awslogs-group  = "/ecs/dev-"      # this should follow the naming convention: env-service.name (which is the name property from several lines above)
    # secrets        = <<EOF
    #             [
    #                 { "name" : "<<<SECRET_KEY>>>", "valueFrom" : "arn:aws:secretsmanager:us-east-1:<<<ACCOUNT-ID>>>:secret:<<<ASM SECRET_NAME>>>:<<<SECRET_KEY>>>::" }, # Copy/Repeat for all environment variables in the ASM Secret
    #             ]
    #             EOF
    # portMappings = <<EOF              # Container ports to expose
    #             [
    #                 {
    # "hostPort"     : 8000,
    # "protocol"     : "tcp",
    # "containerPort": 8000
    #                 }
    #             ]
    #             EOF
    #   }
    # }

    ##### SERVICE NAME #####
    service-name = {
      type                = "<optional-type>"
      service             = "<service-name>"
      name                = "<optional-name>"
      cpu                 = 512
      memory              = 2048
      target_group_prefix = "<prefix>" ## can't be longer than 6 characters
      max_capacity        = 3          #autoscaling max capacity
      min_capacity        = 1          #autoscaling min capacity

      taskDefinitionValues = {
        image          = "<image-url>"
        container_name = "<container-name>"
        container_port = 8000
        host_port      = 8000
        awslogs-region = "<region>"
        awslogs-group  = "<loggroup-path>"
        secrets        = <<EOF
                [
                    { "name" : "<VALUE>", "valueFrom" : "<secret-arn:secret-value>" },
                    { "name" : "<VALUE>", "valueFrom" : "<secret-arn:secret-value>" }
                ]
                EOF
        # Container ports to expose
        portMappings = <<EOF
                [
                    {
                        "hostPort": 8000,
                        "protocol": "tcp",
                        "containerPort": 8000
                    }
                ]
                EOF
        # sidecar_image          = "newrelic/nri-ecs:1.9.5"
        # sidecar_container_name = "newrelic-infra-agent"
        # sidecar_container_port = 80
        # sidecar_host_port      = 80
        # sidecar_secrets        = <<EOF
        #         [
        #             { "name" : "<VALUE>", "valueFrom" : "<secret-arn:secret-value>" },
        #             { "name" : "<VALUE>", "valueFrom" : "<secret-arn:secret-value>" }
        #         ]
        #         EOF

        # # Container ports to expose
        # sidecar_portMappings = <<EOF
        #         [
        #             {
        #                 "hostPort": 80,
        #                 "protocol": "tcp",
        #                 "containerPort": 80
        #             }
        #         ]
        #         EOF
      }
    }

  }
}
