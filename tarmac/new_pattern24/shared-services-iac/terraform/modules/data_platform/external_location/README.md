### Create an external location in Databricks
This module creates an external location in Databricks. The external location is a pointer to a storage location outside of Databricks. 

#### Usage
```hcl

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
  dsci_admin                = "janedoe@schsharedservices.com"
  prefix                    = "product_name"
  tags = {
    Engineer       = "JDoe"
    Resource       = "Managed by Terraform"
    Team           = "Data Platform"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }

}

provider "aws" {
  alias = "databricks_provider_alias_in_my_terraform_code"
  profile = "tf_sdlc"
}

provider "aws" {
  alias = "s3_source_provider_in_my_terraform_code"
  profile = "aws_account_name_profile_where_s3_bucket_is_located"
}
```

Please refer to the [example](../../../../examples/data_platform/external_location.tf) directory for more usage details.

#### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| external_storage_admins_display_name | List of Databricks group names that will have admin access to the external location | `list(string)` | n/a | yes |
| s3_bucket_name | The name of the S3 bucket | `string` | n/a | yes |
| external_storage_label | The label for the external storage | `string` | n/a | yes |
| external_storage_location_label | The label for the external storage location | `string` | n/a | yes |
| external_storage_privileges | List of privileges for the external storage | `list(string)` | n/a | yes |
| databricks_workspace_name | The name of the Databricks workspace | `string` | n/a | yes |
| dsci_admin | The email address of the DSCI admin | `string` | n/a | yes |
| prefix | The prefix for the external location | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | n/a | yes |

#### Providers
| Name | Version |
|------|---------|
| aws.databricks | n/a |
| aws.s3_source | n/a |

Providing the `aws.databricks` and `aws.s3_source` providers is required. The `aws.databricks` provider should be aliased to the databricks workspace in whcih the external storage location should be created and the `aws.s3_source` provider should be aliased to the AWS account where the S3 bucket is located.

#### Outputs
| Name | Description |
|------|-------------|
| external_location_id | The ID of the external location |
