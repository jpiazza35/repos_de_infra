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
| [databricks_permissions.token_usage](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [time_sleep.policy_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_principal_application_ids"></a> [service\_principal\_application\_ids](#input\_service\_principal\_application\_ids) | Service principals that receive CAN\_USE permissions on tokens. | `list(string)` | n/a | yes |
| <a name="input_user_group_names"></a> [user\_group\_names](#input\_user\_group\_names) | Groups that receive CAN\_USE permissions on tokens. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
