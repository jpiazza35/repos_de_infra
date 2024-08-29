app = "fivetran"
env = "prod"
tags = {
  project   = "sullivan-cotter",
  product   = "fivetran",
  service   = "nlb-target-refresher",
  env       = "prod",
  script    = "terraform",
  org_id    = "clinician-nexus",
  repo_name = "data-platform-devops-iac/terraform/fivetran"
}
fivetran_aws_account_id = "834469178297"

lambda = {
  function_name        = "nlb-target-group-ip-refresher"
  description          = "Refreshes the RDS IP addresses used as targets for the NLB target group"
  handler              = "nlb-target-refresher.lambda_handler"
  runtime_version      = "python3.9"
  architectures        = "x86_64"
  timeout              = 3
  memory_size          = 128
  ephemeral_storage    = 512
  requirementsfilename = "requirements.txt"
  codefilename         = "nlb-target-refresher.py"
  working_dir          = "lambda" # relative to the current folder

  variables = {
    #TODO Add env vars here  
  }
}

target_db_instance_ids = ["", ""]

fivetran_cidr = "10.128.0.0/18"

routes = {
  postgresql = {
    listener = {
      port             = "55432"
      protocol         = "TCP"
      action_type      = "default"
      target_group_arn = ""
      # acm_arn          = module.acm.acm
    },
    target_group = {
      vpc_id                             = ""
      name_prefix                        = "fivetran"
      protocol                           = "TCP"
      port                               = 5432
      deregistration_delay               = 300
      target_type                        = "ip"
      load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
      lambda_multi_value_headers_enabled = false
      protocol_version                   = "HTTP1"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 5
        matcher             = null
        path                = null
        port                = 5432
        protocol            = "TCP"
        timeout             = 2
        unhealthy_threshold = 2
      }
      tags = {
        FQDN = "ces-production.cwilbglj8ke5.us-east-1.rds.amazonaws.com"
      }
    }
  },
  aws-va2-sql01 = {
    listener = {
      port             = "41433"
      protocol         = "TCP"
      action_type      = "default"
      target_group_arn = ""
      # acm_arn          = module.acm.acm
    },
    target_group = {
      vpc_id                             = ""
      name_prefix                        = "fivetran"
      protocol                           = "TCP"
      port                               = 1433
      deregistration_delay               = 300
      target_type                        = "ip"
      load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
      lambda_multi_value_headers_enabled = false
      protocol_version                   = "HTTP1"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 5
        matcher             = null
        path                = null
        port                = 1433
        protocol            = "TCP"
        timeout             = 2
        unhealthy_threshold = 2
      }
      tags = {
        FQDN = "aws-va2-sql01.sca.local"
      }
    }
  },
  aws-va2-sql03 = {
    listener = {
      port             = "51433"
      protocol         = "TCP"
      action_type      = "default"
      target_group_arn = ""
      # acm_arn          = module.acm.acm
    },
    target_group = {
      vpc_id                             = ""
      name_prefix                        = "fivetran"
      protocol                           = "TCP"
      port                               = 1433
      deregistration_delay               = 300
      target_type                        = "ip"
      load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
      lambda_multi_value_headers_enabled = false
      protocol_version                   = "HTTP1"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 5
        matcher             = null
        path                = null
        port                = 1433
        protocol            = "TCP"
        timeout             = 2
        unhealthy_threshold = 2
      }
      tags = {
        FQDN = "aws-va2-sql03.sca.local"
      }
    }
  }
}
