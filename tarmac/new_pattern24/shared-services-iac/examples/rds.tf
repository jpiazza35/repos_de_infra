module "rds" {
  source             = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//rds?ref=v1.0.0"
  private_subnet_ids = data.aws_subnets.all[0].ids
  rds_security_group = [
    module.ecs.security_group_id
  ]
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = "RDS"
      Resource    = "Managed by Terraform"
      Description = "phpIPAM Related Configuration"
      Team        = "DevOps"
    }
  )
}
