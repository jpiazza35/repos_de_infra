module "rds_aurora" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//rds_aurora?ref=v1.0.133"
  cluster = {
    cluster_engine                  = var.engine
    cluster_engine_mode             = var.engine_mode
    cluster_engine_version          = var.engine_version
    cluster_apply_immediately       = true
    cluster_database_name           = var.master_db_name
    cluster_master_username         = var.master_db_username
    cluster_backup_retention_period = 7
    skip_final_snapshot             = true
    serverless_scaling_configuration = {
      max_capacity = 3.0
      min_capacity = 0.5
    }
  }

  instance = {
    instance_class = var.instance_class
  }

  # Path of secret to store credentials from RDS
  vault_secret = {
    path = var.vault_path
  }

  # If you want to change RDS password, change this date.
  trigger_rotation = "1970-01-01"

  tags = {
    project = "sullivan-cotter"
    product = var.product_name
    service = "db"
    env     = var.env
    script  = "terraform"
  }
}