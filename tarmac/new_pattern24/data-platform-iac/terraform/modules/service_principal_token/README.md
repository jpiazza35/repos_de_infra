<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_obo_token.token](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/obo_token) | resource |
| [vault_generic_secret.token_secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.token_secret_devops_vault](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_lifetime_seconds"></a> [lifetime\_seconds](#input\_lifetime\_seconds) | n/a | `number` | `null` | no |
| <a name="input_service_principal_application_id"></a> [service\_principal\_application\_id](#input\_service\_principal\_application\_id) | n/a | `string` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_token"></a> [token](#output\_token) | n/a |
| <a name="output_vault_path"></a> [vault\_path](#output\_vault\_path) | n/a |
<!-- END_TF_DOCS -->
