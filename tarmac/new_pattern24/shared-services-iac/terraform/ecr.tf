module "ecr_phpipam_web" {
  source = "./modules/ecr"
  app    = "phpipam-web"
  env    = var.env
  tags   = var.tags
}

module "ecr_phpipam_cron" {
  source = "./modules/ecr"
  app    = "phpipam-cron"
  env    = var.env
  tags   = var.tags
}

module "ecr_incumbent_api" {
  source = "./modules/ecr"
  app    = "app-incumbent-api-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_incumbent_grpc" {
  source = "./modules/ecr"
  app    = "app-incumbent-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_mpt_project_service" {
  source = "./modules/ecr"
  app    = "app-mpt-project-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_mpt_ui" {
  source = "./modules/ecr"
  app    = "app-mpt-ui"
  env    = var.env
  tags   = var.tags
}

module "ecr_organization_grpc" {
  source = "./modules/ecr"
  app    = "app-organization-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_survey_api" {
  source = "./modules/ecr"
  app    = "app-survey-api-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_survey_grpc" {
  source = "./modules/ecr"
  app    = "app-survey-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_user_api" {
  source = "./modules/ecr"
  app    = "app-user-api-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_user_grpc" {
  source = "./modules/ecr"
  app    = "app-user-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_incumbent_db" {
  source = "./modules/ecr"
  app    = "app-incumbent-db"
  env    = var.env
  tags   = var.tags
}

module "ecr_incumbent_staging_db" {
  source = "./modules/ecr"
  app    = "app-incumbent-staging-db"
  env    = var.env
  tags   = var.tags
}

module "ecr_mpt_postgres_db" {
  source = "./modules/ecr"
  app    = "app-mpt-postgres-db"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_ui" {
  source = "./modules/ecr"
  app    = "app-ps-ui"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_performance_service" {
  source = "./modules/ecr"
  app    = "app-ps-performance-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_mpt_data" {
  source = "./modules/ecr"
  app    = "app-mpt-data"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_tenant_api" {
  source = "./modules/ecr"
  app    = "app-ps-tenant-api-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_tenant_grpc" {
  source = "./modules/ecr"
  app    = "app-ps-tenant-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_settings_api" {
  source = "./modules/ecr"
  app    = "app-ps-settings-api-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_settings_grpc" {
  source = "./modules/ecr"
  app    = "app-ps-settings-grpc-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_app_ps_productivity_service" {
  source = "./modules/ecr"
  app    = "app-ps-productivity-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_dwb_service" {
  source = "./modules/ecr"
  app    = "app-dwb-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_dwb_ui" {
  source = "./modules/ecr"
  app    = "app-dwb-ui"
  env    = var.env
  tags   = var.tags
}

module "ecr_bm_service" {
  source = "./modules/ecr"
  app    = "app-bm-service"
  env    = var.env
  tags   = var.tags
}

module "ecr_bm_ui" {
  source = "./modules/ecr"
  app    = "app-bm-ui"
  env    = var.env
  tags   = var.tags
}

module "ecr_ps_websocket" {
  source = "./modules/ecr"
  app    = "app-ps-websocket"
  env    = var.env
  tags   = var.tags
}
