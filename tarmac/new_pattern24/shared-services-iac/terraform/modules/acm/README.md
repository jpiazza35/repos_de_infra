### ALB Module
Call this module using the example below:

```bash
module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm"
  providers = {
    aws            = aws
  }
  env               = var.env
  dns_zone_id       = var.dns_zone_id ## (OPTIONAL) DNS Zone ID for the Route53 record to be created for certificate validation
  dns_name          = "cliniciannexus.com" ## Domain Name e.g. dev.cliniciannexus.com, if blank, will default to the appropriate dns zone for the environment e.g. dev.cliniciannexus.com for dev and qa.cliniciannexus.com for qa
  san               = [] ## (OPTIONAL) List of domain names that should be added to the certificate, if left blank, create_wildcard must be true and only a wildcard cert will be created
  create_wildcard   = true ## Should a wildcard certificate be created, if false, you must specify value(s) for the `san` variable
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
```
