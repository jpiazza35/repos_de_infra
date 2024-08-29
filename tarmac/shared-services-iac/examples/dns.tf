module "dns" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns?ref=v1.0.0"
  providers = {
    aws            = aws
    aws.infra_prod = aws.ss_network
  }
  env               = var.env
  vpc_id            = var.vpc_id           ## VPC ID of current account e.g. `D_EKS` to attach to a private hosted zone
  lb_dns_name       = var.lb_dns_name      ## DNS Name of the Load Balancer
  lb_dns_zone       = var.lb_dns_zone      ## DNS Zone of the Load Balancer
  dns_name          = "cliniciannexus.com" ## Domain Name e.g. dev.cliniciannexus.com
  record_prefix     = []                   ## list of record names that should be created
  hosted_zone_name  = ""                   ## Custom hosted Zone name to be created, if left blank, the value of the `dns_name` variable is used
  create_local_zone = false                ## Should a local zone be created - If a `VPC_ID` is provided, a private hosted zone will be created, if omitted, a public hosted zone will be created
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = var.app ## Application/Product the DNS is for e.g. ecs, argocd
      Resource    = "Managed by Terraform"
      Description = "DNS Related Configuration"
      Team        = "DevOps" ## Name of the team requesting the creation of the DNS resource
    }
  )
}
