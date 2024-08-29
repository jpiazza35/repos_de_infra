<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_global_init_script.init](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/global_init_script) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bsr_password"></a> [bsr\_password](#input\_bsr\_password) | n/a | `any` | n/a | yes |
| <a name="input_bsr_url"></a> [bsr\_url](#input\_bsr\_url) | n/a | `string` | `"clinician-nexus.buf.dev/gen/python"` | no |
| <a name="input_bsr_user"></a> [bsr\_user](#input\_bsr\_user) | n/a | `any` | n/a | yes |
| <a name="input_create_global_script"></a> [create\_global\_script](#input\_create\_global\_script) | Whether or not to create a workspace wide init script | `bool` | `true` | no |
| <a name="input_nexus_base_url"></a> [nexus\_base\_url](#input\_nexus\_base\_url) | n/a | `any` | n/a | yes |
| <a name="input_nexus_password"></a> [nexus\_password](#input\_nexus\_password) | n/a | `any` | n/a | yes |
| <a name="input_nexus_url"></a> [nexus\_url](#input\_nexus\_url) | URL without https:// | `any` | n/a | yes |
| <a name="input_nexus_user"></a> [nexus\_user](#input\_nexus\_user) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_script"></a> [script](#output\_script) | n/a |
<!-- END_TF_DOCS -->
