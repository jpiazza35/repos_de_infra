<!-- BEGIN_TF_DOCS -->
## Terraform Configuration Summary: Environment and Profile Management

This Terraform configuration is designed for managing environment-specific settings and profiles in a multi-environment setup. It utilizes local variables and outputs to handle configurations for different environments like development, SDL (Software Development Lifecycle), production, and preview. The key elements include:

- **Local Variables Mapping**:
  - `env_map`: Maps environment names (dev, sdlc, prod, preview) to their respective identifiers used within the data platform.
  - `role_prefix_map`: Associates environments with role prefixes. Notably, these prefixes are not consistent across all groups due to external AD group provisioning.
  - `env_prefix`: Maps environments to prefixes used for Databricks catalog names.
  - `aws_databricks_profile`: Specifies AWS profiles for Databricks in different environments.
  - `aws_data_platform_profile`: Defines AWS profiles for the data platform, differentiated per environment.
  - `databricks_profile`: Contains Terraform profiles for Databricks for each environment.

- **Output Variables**:
  - `output "env"`: Outputs the environment identifier based on the current Terraform workspace.
  - `output "env_prefix"`: Provides the prefix for Databricks catalog names, specific to each environment.
  - `output "role_prefix"`: Outputs the role prefix for the current environment.
  - `output "aws_profile_databricks"`: Returns the AWS profile for Databricks for the selected workspace.
  - `output "aws_profile_data_platform"`: Outputs the AWS profile for the data platform, tailored to the current environment.
  - `output "databricks_profile"`: Gives the Terraform profile for Databricks corresponding to the workspace.

Key Aspects:
- **Flexibility and Customization**: This setup allows for easy adaptation to various environments, catering to their unique configurations and requirements.
- **Centralized Management**: Keeps environment and profile settings centralized, making it easier to manage and update configurations across different environments.
- **Environment-specific Tailoring**: Ensures that resources and settings are correctly aligned with the intended environment, enhancing consistency and reducing configuration errors.

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Force the user into using a workspace, then return common profile information. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_profile_data_platform"></a> [aws\_profile\_data\_platform](#output\_aws\_profile\_data\_platform) | n/a |
| <a name="output_aws_profile_databricks"></a> [aws\_profile\_databricks](#output\_aws\_profile\_databricks) | n/a |
| <a name="output_databricks_profile"></a> [databricks\_profile](#output\_databricks\_profile) | n/a |
| <a name="output_env"></a> [env](#output\_env) | n/a |
| <a name="output_env_prefix"></a> [env\_prefix](#output\_env\_prefix) | This is used for the databricks catalog names, like p\_source\_oriented |
| <a name="output_role_prefix"></a> [role\_prefix](#output\_role\_prefix) | n/a |
<!-- END_TF_DOCS -->
