config = {

  ## Provider variables
  region  = "us-east-1"
  profile = "internaltool-prod"


  ## Environment variables
  tags = {
    "Environment" : "prod"
    "Name" : "internal-tool-prod"
    "Project" : "internal-tool"
  }

  environment = "prod"

  ## IAM user/group variables
  iam_minimum_password_length               = 8
  iam_password_require_lowercase_characters = true
  iam_password_require_uppercase_characters = true
  iam_password_require_numbers              = true
  iam_password_require_symbols              = true
  iam_max_password_age                      = 45
  iam_allow_users_to_change_password        = true
  iam_password_reuse_prevention             = 5
  iam_users = {
    branko_mandil = {
      name  = "branko.mandil@tarmac.io"
      group = ["TarmacDevOps"]
    },
    damian_bruera = {
      name  = "damian.bruera@tarmac.io"
      group = ["TarmacDevOps"]
    },
    internal_tool_user = {
      name  = "internal-tool-user"
      group = []
    },
    riste_trenchev = {
      name  = "riste.trenchev@tarmac.io"
      group = ["TarmacDevOps"]
    },
    tarmacInternalCircleCI = {
      name  = "tarmacInternalCircleCI"
      group = ["TarmacCircleCI"]
    },

  }

  iam_group = [
    "TarmacCircleCI",
    "TarmacDevOps",
  ]
  ## s3 Bucket variables
  s3_bucket_envs                     = { "Bucket" : "tarmac-internal-tool-prod" }
  s3_bucket_name                     = "tarmac-internal-tool-prod"
  s3_bucket_prefix                   = ""
  s3_bucket_acl                      = "private"
  s3_bucket_block_public_acls        = true
  s3_bucket_block_public_policy      = true
  s3_bucket_block_public_restrict    = true
  s3_bucket_block_public_ignore_acls = true

  ## Cloudfront variables
  cloudfront_default_root_object = "index.html"
  cloudfront_error_code          = 403
  cloudfront_response_code       = 200
  cloudfront_response_page_path  = "/index.html"
  cloudfront_origin_id           = "tarmac-internal-tool-prod.s3.us-east-1.amazonaws.com"

  ## VPC variables
  vpc_cidr_block           = "10.1.0.0/16"
  vpc_tags                 = { Name = "internal-tool" }
  subnet_availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]

  subnet_public_map_public_ip             = true
  route_internet_gateway_destination_cidr = "0.0.0.0/0"
  default_vpc_segurity_group_name         = "default-vpc-sg"
  public_dns                              = "example.tarmac.com"
  private_dns                             = ""

  # EC2 variables
  key_pair                    = "internal_tool_vpn_prod"
  instance_ami                = "ami-0810d703c9dff49b4" # capa-ami-ubuntu-18.04-v1.26.0-1671514382
  instance_type               = "t3.micro"
  tarmac_mkd_office_static_ip = "0.0.0.0/0" # "78.157.1.105/32"
  ec2_tags                    = { Name = "internal-tool" }

  ## RDS variables
  db_cluster_identifier              = "tarmac-internal-tool-prod"
  db_cluster_engine                  = "aurora-mysql"
  db_cluster_engine_version          = "8.0.mysql_aurora.3.02.2"
  db_cluster_instance_class          = "db.t3.medium"
  db_cluster_availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  db_cluster_database_name           = "tarmacinternaltool"
  db_cluster_master_username         = "tarmacuser"
  db_cluster_backup_retention_period = 7
  db_cluster_storage_encrypted       = true
  db_cluster_root_password_length    = 20
  db_cluster_subnet_group_name       = "intenal-tool"
  db_cluster_tags                    = { Name = "internal-tool" }
  # db_cluster_subnet_database_id      = ["subnet-00b645bff3ffba657", "subnet-0f8dec1852356d00e", "subnet-0f4e4991d75576475"]
  db_cluster_apply_immediately = true
  db_cluster_kms_key           = "arn:aws:kms:us-east-1:616333796072:key/9eb2e173-d791-4364-a983-f4553f89dc1e"

  ## Load balancer variables
  load_balancer_name                = "application-load-balancer-prod"
  load_balancer_internal            = false
  load_balancer_type                = "application"
  load_balancer_deletion_protection = false
  load_balancer_log_prefix          = "lb-log"
  load_balancer_log_enabled         = true
  load_balancer_bucket_log_name     = "default-load-balancer-log-prod"
  alb_priority                      = 99


  ## ECS variables
  ecs_cluster_name = "ecs-internal-tool-prod"
  exec_command     = false

  services = {
    ##### SERVICE TEMPLATE #####
    /*
    backend = {
      type                = "public"       # value can be public/private/worker
      service             = "internaltool" # short service name (will be used as subdomain for the internal dns
      name                = "internaltool" # named used in the resource naming
      cpu                 = 256            # cpu size of each task 256 = 0.25 cores
      memory              = 512            # memory size of each task in MB
      target_group_prefix = "tool"         # can't be longer than 6 characters
      healthcheck_path    = ""             # health check path. This is not needed when type = worker

      taskDefinitionValues = {
        image          = "" # container image arn (can be copied from ECR)
        container_name = "internaltool"
        container_port = 8000 # Preferred port is 8000
        host_port      = 8000
        awslogs-region = "us-east-1"
        awslogs-group  = "/ecs/dev-" # this should follow the naming convention: env-service.name (which is the name property from several lines above)
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
      }
*/
    ##### SERVICE NAME #####
    service-name = {
      type                = "public"
      service             = "internaltool-prod"
      name                = "internaltool-prod"
      cpu                 = 512
      memory              = 2048
      target_group_prefix = "tool" ## can't be longer than 6 characters
      max_capacity        = 30     #autoscaling max capacity
      min_capacity        = 1      #autoscaling min capacity
      healthcheck_path    = "/health"

      taskDefinitionValues = {
        image          = "616333796072.dkr.ecr.us-east-1.amazonaws.com/backend:latest"
        container_name = "internaltool-prod"
        container_port = 8080
        host_port      = 8080
        awslogs-region = "us-east-1"
        awslogs-group  = "/ecs/prod/internaltool-prod"
        secrets        = <<EOF
                [
                    { "name": "MYSQL_DATABASE", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/MYSQL_DATABASE" },
                    { "name": "MYSQL_USER", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/MYSQL_USER" },
                    { "name": "MYSQL_HOST", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/MYSQL_HOST" },
                    { "name": "MYSQL_PORT", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/MYSQL_PORT" },
                    { "name": "APP_PORT", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/APP_PORT" },
                    { "name": "MYSQL_PASSWORD", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/MYSQL_PASSWORD" },
                    { "name": "BAMBOO_LOGIN", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_LOGIN" },
                    { "name": "BAMBOO_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_KEY" },
                    { "name": "BAMBOO_ORG", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_ORG" },
                    { "name": "BAMBOO_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_URL" },
                    { "name": "BAMBOO_API_GATEWAY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_API_GATEWAY" },
                    { "name": "BAMBOO_WEBHOOK_PRIVATE_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/BAMBOO_WEBHOOK_PRIVATE_KEY" },
                    { "name": "AUTH_REGION", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AUTH_REGION" },
                    { "name": "AWS_AUTH_USER_POOL_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_AUTH_USER_POOL_ID" },
                    { "name": "AWS_AUTH_USER_POOL_WEB_CLIENT_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_AUTH_USER_POOL_WEB_CLIENT_ID" },
                    { "name": "AUTH_IDENTITY_POOL_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AUTH_IDENTITY_POOL_ID" },
                    { "name": "AWS_REGION", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_REGION" },
                    { "name": "AWS_ACCESS_KEY_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_ACCESS_KEY_ID" },
                    { "name": "AWS_SECRET_ACCESS_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_SECRET_ACCESS_KEY" },
                    { "name": "AWS_PUBLIC_BUCKET_NAME", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_PUBLIC_BUCKET_NAME" },
                    { "name": "AWS_S3_FORCE_PATH_STYLE", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_S3_FORCE_PATH_STYLE" },
                    { "name": "AWS_S3_SIGNATURE_VERSION", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_S3_SIGNATURE_VERSION" },
                    { "name": "AWS_URL_EXPIRE_TIME", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/AWS_URL_EXPIRE_TIME" },
                    { "name": "SLACK_WEBHOOK_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_WEBHOOK_URL" },
                    { "name": "SLACK_INTERNAL_HOURS_TRACKER_DEBUG_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_INTERNAL_HOURS_TRACKER_DEBUG_URL" },
                    { "name": "SLACK_INTERNAL_HOURS_TRACKER_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_INTERNAL_HOURS_TRACKER_URL" },
                    { "name": "CLOCKIFY_WORKSPACE_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/CLOCKIFY_WORKSPACE_ID" },
                    { "name": "CLOCKIFY_API_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/CLOCKIFY_API_KEY" },
                    { "name": "CLOCKIFY_USER_ID", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/CLOCKIFY_USER_ID" },
                    { "name": "CLOCKIFY_BASE_ENDPOINT", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/CLOCKIFY_BASE_ENDPOINT" },
                    { "name": "CLOCKIFY_REPORTS_ENDPOINT", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/CLOCKIFY_REPORTS_ENDPOINT" },
                    { "name": "INTERNAL_TEAM_BASE_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/INTERNAL_TEAM_BASE_URL" },
                    { "name": "INTERNAL_TEAM_API_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/INTERNAL_TEAM_API_KEY" },
                    { "name": "NODE_ENV", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/NODE_ENV" },
                    { "name": "SLACK_NOTIFICATION_APP_INCOMING_URL", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_NOTIFICATION_APP_INCOMING_URL" },
                    { "name": "SLACK_NOTIFICATION_APP_BOT_TOKEN", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_NOTIFICATION_APP_BOT_TOKEN" },
                    { "name": "SLACK_NOTIFICACION_APP_ENABLED", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/SLACK_NOTIFICACION_APP_ENABLED" },
                    { "name": "API_KEY", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/API_KEY" },
                    { "name": "GRAPHQL_PLAYGROUND_PASSWORD", "valueFrom": "arn:aws:ssm:us-east-1:616333796072:parameter/prod/internaltool/GRAPHQL_PLAYGROUND_PASSWORD" }
                ]
                EOF
        # Container ports to expose

        portMappings = <<EOF
                [
                    {
                        "hostPort": 8080,
                        "protocol": "tcp",
                        "containerPort": 8080
                    }
                ]
                EOF

      }
    }

  }

  oidc = {
    providerName   = "CircleCI"
    organization   = "441631a8-4be4-4b51-bb18-8dccf4663c25"
    providerUrl    = "https://oidc.circleci.com/org"
    thumbprintList = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
    ecrBackendName = "backend"
  }


  ### COGNITO

  cognito = {
    name   = "googleonly"
    domain = "tarmacinternaltoolprod"
    password_policy = {
      minimum_length                   = 8
      require_lowercase                = true
      require_numbers                  = true
      require_uppercase                = true
      require_symbols                  = true
      temporary_password_validity_days = 7
    }

    provider_name = "Google"
    provider_type = "Google"

    provider_details = {
      authorize_scopes = "email"
    }

    attribute_mapping = {
      email          = "email"
      username       = "sub"
      email_verified = "email_verified"
      name           = "name"
    }

    recovery_mechanisms = [
      {
        name     = "verified_email"
        priority = 1
      },
      {
        name     = "verified_phone_number"
        priority = 2
      }
    ]
  }
  #wAF

  waf = {
    rules = [
      {
        name                                     = "AWS-BotControlRuleSet"
        priority                                 = 0
        managed_rule_group_statement_name        = "AWSManagedRulesBotControlRuleSet"
        managed_rule_group_statement_vendor_name = "AWS"
        cloudwatch_metrics_enabled               = true
        metric_name                              = "AWS-AWSManagedRulesBotControlRuleSet"
        sampled_requests_enabled                 = true
      },
      {
        name                                     = "AWS-CommonRuleSet"
        priority                                 = 1
        managed_rule_group_statement_name        = "AWSManagedRulesCommonRuleSet"
        managed_rule_group_statement_vendor_name = "AWS"
        cloudwatch_metrics_enabled               = true
        metric_name                              = "AWS-AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled                 = true
      },
      {
        name                                     = "AWS-AmazonIpReputationList"
        priority                                 = 2
        managed_rule_group_statement_name        = "AWSManagedRulesAmazonIpReputationList"
        managed_rule_group_statement_vendor_name = "AWS"
        cloudwatch_metrics_enabled               = true
        metric_name                              = "AWS-ManagedRulesAmazonIpReputationList"
        sampled_requests_enabled                 = true
      },
      {
        name                                     = "AWS-KnownBadInputs"
        priority                                 = 3
        managed_rule_group_statement_name        = "AWSManagedRulesKnownBadInputsRuleSet"
        managed_rule_group_statement_vendor_name = "AWS"
        cloudwatch_metrics_enabled               = true
        metric_name                              = "AWS-ManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled                 = true
      }
    ]
  }
}