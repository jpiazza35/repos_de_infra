locals {
  external_location_qualifier = {
    "sdlc"    = "sandbox"
    "preview" = "preview"
    "prod"    = "prod"
  }
}

module "ces_external_location" {
  source                      = "../modules/external_location"
  name                        = "ces_${local.external_location_qualifier[terraform.workspace]}_external_location"
  s3_bucket                   = var.ces_bucket
  create_bucket               = false
  role_prefix                 = module.workspace_vars.role_prefix
  storage_credential_iam_role = module.default_storage_credential.iam_role_name
  storage_credential_name     = module.default_storage_credential.storage_credential_name
  permission_mode             = "READ_ONLY"
}
