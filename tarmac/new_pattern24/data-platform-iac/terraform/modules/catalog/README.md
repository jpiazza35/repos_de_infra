<!-- BEGIN_TF_DOCS -->
# Terraform Module for Databricks Catalog Provisioning
This Terraform module is designed to provision and manage a Databricks catalog along with its associated resources. The key components and functionalities include:

- Catalog Creation: The databricks\_catalog resource creates a Databricks catalog with specified properties like name, comment, isolation mode, and storage root.

- External Location Management: The module "external\_location" manages external locations for the catalog, setting up necessary IAM roles and storage credentials.

- Schema and Volume Provisioning: The module handles the creation of schemas (databricks\_schema) and volumes (databricks\_volume) within the catalog, including storage configurations.

- Granting Permissions: It manages permissions through databricks\_grants for different roles like engineers, users, admins, and service principals. This includes privileges on the catalog, schemas, and volumes.

- Dynamic Grant Management: Utilizes dynamic blocks to efficiently manage and assign privileges based on various criteria and role definitions.

- Dependency Handling: Ensures proper sequence of resource creation and management through depends\_on attributes, maintaining the integrity of the provisioning process.

- Sleep Resource: Includes a time\_sleep resource to manage timing dependencies, ensuring proper sequencing of resource provisioning.

This module is highly configurable, with options to set environment prefixes, role prefixes, account IDs, and other variables to tailor the setup to specific requirements. It emphasizes security and fine-grained access control, making it suitable for complex and secure data environments.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_external_location"></a> [external\_location](#module\_external\_location) | ../external_location | n/a |
| <a name="module_schema_external_locations"></a> [schema\_external\_locations](#module\_schema\_external\_locations) | ../external_location | n/a |

## Resources

| Name | Type |
|------|------|
| [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_grants.catalog_grants](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.schema_grants](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.volumes](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_schema.schemas](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema) | resource |
| [databricks_volume.schema_volume](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/volume) | resource |
| [time_sleep.catalog_grant](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account number of the databricks workspace. | `any` | n/a | yes |
| <a name="input_catalog_grants"></a> [catalog\_grants](#input\_catalog\_grants) | Additional catalog level grants, outside of the default, can be configured here. | <pre>list(object({<br>    principal  = string<br>    privileges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_catalog_name"></a> [catalog\_name](#input\_catalog\_name) | n/a | `any` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `"Managed by Terraform"` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_env_prefix"></a> [env\_prefix](#input\_env\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_metastore_id"></a> [metastore\_id](#input\_metastore\_id) | n/a | `string` | n/a | yes |
| <a name="input_owner_service_principal_id"></a> [owner\_service\_principal\_id](#input\_owner\_service\_principal\_id) | The application id of the service principal that will retain ownership over all catalogs and schemas. | `any` | n/a | yes |
| <a name="input_principal_lookup"></a> [principal\_lookup](#input\_principal\_lookup) | If additional grants on schemas are to be made, this map can be used to lookup the principal name required for `databricks_grants`. | `map(string)` | `{}` | no |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_schema_grants"></a> [schema\_grants](#input\_schema\_grants) | Schemas can only have a single `databricks_grants` resource. By default, only the grants are configured at the `catalog` level. If you need to configure grants at the schema level, you can do so here. | <pre>map(list(object({<br>    principal  = string<br>    privileges = list(string)<br>  })))</pre> | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | n/a | `list(string)` | n/a | yes |
| <a name="input_schemas_get_isolated_buckets"></a> [schemas\_get\_isolated\_buckets](#input\_schemas\_get\_isolated\_buckets) | By default, the catalog will have a single bucket that all schemas are stored in. With this turned on, each schema will have its own bucket in addition to the catalog root bucket. | `bool` | `false` | no |
| <a name="input_storage_credential_iam_role"></a> [storage\_credential\_iam\_role](#input\_storage\_credential\_iam\_role) | n/a | `string` | n/a | yes |
| <a name="input_storage_credential_name"></a> [storage\_credential\_name](#input\_storage\_credential\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_id"></a> [catalog\_id](#output\_catalog\_id) | n/a |
| <a name="output_catalog_name"></a> [catalog\_name](#output\_catalog\_name) | n/a |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | n/a |
<!-- END_TF_DOCS -->
