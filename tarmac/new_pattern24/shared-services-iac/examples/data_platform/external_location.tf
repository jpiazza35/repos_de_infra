module "external_location" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac.git//terraform/modules/data_platform/external_location?ref=1.0.202"

  providers = {
    aws.databricks = aws.databricks_provider_alias_in_my_terraform_code
    aws.s3_source  = aws.s3_source_provider_in_my_terraform_code
  }

  external_storage_admins_display_name = [
    "databricks_group_name_1",
    "databricks_group_name_2"
  ]
  s3_bucket_name                  = "external_bucket_name"
  external_storage_label          = "databricks_external_label_name"
  external_storage_location_label = "databricks_external_location_label"
  external_storage_privileges = [
    "ALL_PRIVILEGES"
  ]
  databricks_workspace_name = "sdlc"
  dsci_admin                = "janedoe@cliniciannexus.com"
  prefix                    = "product_name"
  tags = {
    Engineer       = "JDoe"
    Resource       = "Managed by Terraform"
    Team           = "Data Platform"
    Component      = "Databricks External Location"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }

}

provider "aws" {
  alias   = "databricks_provider_alias_in_my_terraform_code"
  profile = "tf_sdlc"
}

provider "aws" {
  alias   = "s3_source_provider_in_my_terraform_code"
  profile = "aws_account_name_profile_where_s3_bucket_is_located"
}
