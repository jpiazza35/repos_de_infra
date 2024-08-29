<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vault_secret"></a> [vault\_secret](#module\_vault\_secret) | ../sql_endpoint_vault | n/a |
| <a name="module_workspace_vars"></a> [workspace\_vars](#module\_workspace\_vars) | ../workspace_variable_transformer | n/a |

## Resources

| Name | Type |
|------|------|
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_stop_mins"></a> [auto\_stop\_mins](#input\_auto\_stop\_mins) | n/a | `number` | `15` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | n/a | `string` | `"2X-Small"` | no |
| <a name="input_create_vault_secret"></a> [create\_vault\_secret](#input\_create\_vault\_secret) | n/a | `bool` | `true` | no |
| <a name="input_enable_serverless_compute"></a> [enable\_serverless\_compute](#input\_enable\_serverless\_compute) | n/a | `bool` | `true` | no |
| <a name="input_max_num_clusters"></a> [max\_num\_clusters](#input\_max\_num\_clusters) | n/a | `number` | `2` | no |
| <a name="input_min_num_clusters"></a> [min\_num\_clusters](#input\_min\_num\_clusters) | n/a | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_spot_instance_policy"></a> [spot\_instance\_policy](#input\_spot\_instance\_policy) | n/a | `string` | `"RELIABILITY_OPTIMIZED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `any` | `{}` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | n/a | `string` | `"PRO"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_source_id"></a> [data\_source\_id](#output\_data\_source\_id) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_jdbc_url"></a> [jdbc\_url](#output\_jdbc\_url) | n/a |
| <a name="output_odbc_params"></a> [odbc\_params](#output\_odbc\_params) | n/a |
| <a name="output_vault_path"></a> [vault\_path](#output\_vault\_path) | n/a |
<!-- END_TF_DOCS -->
