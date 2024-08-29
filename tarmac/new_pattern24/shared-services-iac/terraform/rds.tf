module "rds" {
  source             = "./modules/rds"
  db_name            = "phpipam"
  private_subnet_ids = data.aws_subnets.all[0].ids
  rds_security_group = [
    module.ecs.security_group_id
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "RDS"
      Resource       = "Managed by Terraform"
      Description    = "phpIPAM Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

module "oncall_mysql_rds" {
  source             = "./modules/rds"
  engine             = "mysql"
  engine_version     = "8.0"
  parameters_name    = "mysql-params"
  parameters_family  = "mysql8.0"
  identifier         = "oncall-mysql"
  db_name            = "oncall"
  name               = "oncall-mysql"
  subnet_name        = "oncall"
  private_subnet_ids = data.aws_subnets.all[0].ids
  rds_security_group = [
    module.ecs.security_group_id
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "RDS"
      Resource       = "Managed by Terraform"
      Description    = "Oncall Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

module "incident_bot_psql_rds" {
  source                          = "./modules/rds"
  engine                          = "postgres"
  engine_version                  = "16.2"
  parameters_name                 = "psql-params"
  parameters_family               = "postgres16"
  identifier                      = "incident-bot-psql"
  db_name                         = "incident_bot"
  name                            = "incident-bot-psql"
  subnet_name                     = "incident-bot"
  user_name                       = "incidentbot"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  private_subnet_ids              = data.aws_subnets.all[0].ids
  rds_security_group = [
    aws_security_group.incident_bot_rds[0].id
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "RDS"
      Resource       = "Managed by Terraform"
      Description    = "Incident Bot Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
