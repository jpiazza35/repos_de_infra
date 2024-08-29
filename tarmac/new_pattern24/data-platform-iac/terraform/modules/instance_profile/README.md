<!-- BEGIN_TF_DOCS -->
## Terraform Configuration Summary: AWS IAM Role and Policy Management for Databricks Instance

This Terraform configuration sets up AWS IAM roles, policies, and instance profiles, specifically tailored for a Databricks environment. The key resources in this configuration are:

- **AWS IAM Role (`aws_iam_role.this`)**: Creates an IAM role with a naming convention based on a qualified name and an assume role policy specifically for EC2.

- **AWS IAM Policy (`aws_iam_policy.this_policy`)**: Defines a custom IAM policy with a name based on the qualified name and a policy document passed as a variable.

- **AWS IAM Role Policy Attachment (`aws_iam_role_policy_attachment.s3_access`)**: Attaches the custom IAM policy to the created IAM role.

- **AWS IAM Policy (`aws_iam_policy.pass_role`)**: Creates an IAM policy for passing roles across accounts, named distinctively for shared use and based on a policy document.

- **AWS IAM Role Policy Attachment (`aws_iam_role_policy_attachment.cross_account`)**: Attaches the cross-account pass role policy to a specified cross-account IAM role.

- **AWS IAM Instance Profile (`aws_iam_instance_profile.artifact`)**: Configures an IAM instance profile with a name based on the qualified name, associated with the created IAM role.

- **Time Sleep Resource (`time_sleep.iam_pass_propagate`)**: Incorporates a delay to account for propagation time in IAM role policy attachments, particularly for cross-account scenarios.

- **Databricks Instance Profile (`databricks_instance_profile.this`)**: Creates a Databricks instance profile, depending on the IAM role and policy setup completion, and uses the ARN of the AWS IAM instance profile.

This configuration is essential for setting up secure and functional IAM roles and policies for Databricks instances in AWS, ensuring proper access controls and cross-account interactions.

### Usage
Instance policies are securable objects in Unity Catalog, meaning they need to have `databricks_permissions` alongside them.
By default, admins can use any `instance_profile`. If you can't see an instance profile in the UI, you likely did not configure
access for yourself.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.artifact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.pass_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.this_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cross_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [databricks_instance_profile.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/instance_profile) | resource |
| [time_sleep.iam_pass_propagate](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.assume_role_for_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pass_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_iam_policy_json"></a> [iam\_policy\_json](#input\_iam\_policy\_json) | IAM policy JSON that must be created in the target account of the IAM role. It will be linked to trust the Databricks account. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the instance profile to create | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | n/a |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | n/a |
<!-- END_TF_DOCS -->
