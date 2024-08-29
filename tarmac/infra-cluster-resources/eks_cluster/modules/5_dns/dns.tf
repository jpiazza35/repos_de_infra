module "dns_argocd" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns?ref=1.0.78"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env         = var.environment
  vpc_id      = var.vpc_id
  lb_dns_name = data.aws_lb.load_balancer.dns_name
  lb_dns_zone = data.aws_lb.load_balancer.zone_id

  dns_name          = var.environment == "prod" ? "cliniciannexus.com" : "${var.environment}.cliniciannexus.com"
  create_local_zone = false
  record_prefix = [
    "argocd"
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.environment
      App            = "ArgoCD"
      Resource       = "Managed by Terraform"
      Description    = "DNS Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/infra-cluster-resources"
    }
  )

}

module "dns_mpt" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns?ref=1.0.78"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env         = var.environment
  vpc_id      = var.vpc_id
  lb_dns_name = data.aws_lb.load_balancer.dns_name
  lb_dns_zone = data.aws_lb.load_balancer.zone_id

  dns_name          = var.environment == "prod" ? "cliniciannexus.com" : "${var.environment}.cliniciannexus.com"
  create_local_zone = false
  record_prefix = [
    "mpt"
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.environment
      App            = "MPT"
      Resource       = "Managed by Terraform"
      Description    = "DNS Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/infra-cluster-resources"
    }
  )

}


# module "dns_monitoring" {
#   source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns?ref=1.0.78"
#   providers = {
#     aws            = aws
#     aws.ss_network = aws.ss_network
#   }
#   env         = var.environment
#   vpc_id      = var.vpc_id
#   lb_dns_name = data.aws_lb.load_balancer.dns_name
#   lb_dns_zone = data.aws_lb.load_balancer.zone_id

#   dns_name          = var.environment == "prod" ? "cliniciannexus.com" : "${var.environment}.cliniciannexus.com"
#   create_local_zone = false
#   record_prefix = [
#     "monitoring"
#   ]
#   tags = merge(
#     var.tags,
#     {
#       Environment = var.environment
#       App         = "Monitoring"
#       Resource    = "Managed by Terraform"
#       Description = "DNS Related Configuration"
#       Team        = "DevOps"
#     }
#   )

# }