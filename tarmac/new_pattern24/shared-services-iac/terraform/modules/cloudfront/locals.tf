locals {

  domain_name = var.env == "prod" || var.env == "preview" ? format("*.%s", var.domain_name) : format("*.%s.%s", var.env, var.domain_name)

  r53_domain_name = var.env == "prod" ? format("%s.", var.domain_name) : format("%s.%s.", var.env, var.domain_name)

  cf_alternate_domains = var.env == "prod" ? [format("%s.%s", var.app, var.domain_name)] : [format("%s.%s.%s", var.app, var.env, var.domain_name)]

  cf_r53_zone = var.env == "prod" || var.env == "preview" ? format("%s.", var.domain_name) : format("%s.%s.", var.env, var.domain_name)

  r53_record = [
    for cf in var.cloudfront : [
      for alias in cf.aliases == null || try(length(cf.aliases), []) == 0 ? local.cf_alternate_domains : cf.aliases : {
        name  = cf.name
        alias = alias
      }
    ]
  ]

  flat_r53_record = flatten(local.r53_record)
}
