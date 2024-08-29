<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_grants.catalog_grants](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.schema_grants](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_schema.schemas](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema) | resource |
| [time_sleep.catalog_grant](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog_grants"></a> [catalog\_grants](#input\_catalog\_grants) | Additional catalog level grants, outside of the default, can be configured here. | <pre>list(object({<br>    principal  = string<br>    privileges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_catalog_name"></a> [catalog\_name](#input\_catalog\_name) | n/a | `any` | n/a | yes |
| <a name="input_catalog_prefix"></a> [catalog\_prefix](#input\_catalog\_prefix) | The prefix to be used for the catalog name. | `string` | `""` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `"Managed by Terraform"` | no |
| <a name="input_isolation_mode"></a> [isolation\_mode](#input\_isolation\_mode) | The isolation mode for the catalog. The values are ISOLATED for limiting visiblity to the current workspace, and OPEN for visibility in all workspaces. | `string` | `"ISOLATED"` | no |
| <a name="input_metastore_id"></a> [metastore\_id](#input\_metastore\_id) | n/a | `string` | n/a | yes |
| <a name="input_principal_lookup"></a> [principal\_lookup](#input\_principal\_lookup) | If additional grants on schemas are to be made, this map can be used to lookup the principal name required for `databricks_grants`. | `map(string)` | `{}` | no |
| <a name="input_provider_name"></a> [provider\_name](#input\_provider\_name) | The name of the Delta Sharing provider to use for the catalog. | `string` | n/a | yes |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_schema_grants"></a> [schema\_grants](#input\_schema\_grants) | Schemas can only have a single `databricks_grants` resource. By default, only the grants are configured at the `catalog` level. If you need to configure grants at the schema level, you can do so here. NOTE: The Modify privilege is not allowed on Delta Sharing schemas and will be ignored if set here. | <pre>map(list(object({<br>    principal  = string<br>    privileges = list(string)<br>  })))</pre> | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | n/a | `list(string)` | n/a | yes |
| <a name="input_share_name"></a> [share\_name](#input\_share\_name) | The name of the Delta Sharing share to use for the catalog. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_id"></a> [catalog\_id](#output\_catalog\_id) | n/a |
| <a name="output_catalog_name"></a> [catalog\_name](#output\_catalog\_name) | n/a |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | n/a |
<!-- END_TF_DOCS -->