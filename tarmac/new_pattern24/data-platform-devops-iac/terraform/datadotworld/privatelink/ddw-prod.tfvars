app = "data-world"
env = "prod"
tags = {
  project   = "sullivan-cotter",
  product   = "data_dot_world",
  service   = "nlb-target-refresher",
  env       = "prod",
  script    = "terraform",
  org_id    = "clinician-nexus",
  repo_name = "data-platform-devops-iac/terraform/dataworld"
}
data_dot_world_aws_account_id = "465428570792"

target_db_instance_ids = ["", ""]

data_dot_world_cidr = "10.3.0.0/16" ## need to get this from DDW

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
      name_prefix                        = "ddw"
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
        FQDN = "ces-prod-db-replica.sullivancotter.com"
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
      name_prefix                        = "ddw"
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
      name_prefix                        = "ddw"
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
  },
  https-route = {
    ## for databricks and tableau and possibly s3
    listener = {
      port             = "443"
      protocol         = "TCP"
      action_type      = "default"
      target_group_arn = ""
      # acm_arn          = module.acm.acm
    },
    target_group = {
      vpc_id                             = ""
      name_prefix                        = "ddw"
      protocol                           = "TCP"
      port                               = 443
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
        port                = 443
        protocol            = "TCP"
        timeout             = 2
        unhealthy_threshold = 2
      }
      tags = {
        FQDN = "https"
      }
    }
  }
}
