<!-- BEGIN_TF_DOCS -->
## Terraform Configuration Summary: Databricks External Location with S3 Access

This Terraform configuration is designed to set up and manage a Databricks external location with access to an AWS S3 bucket. Key resources and configurations include:

- **AWS IAM Role Policy Attachment (`aws_iam_role_policy_attachment.s3_access_attachment`)**: Attaches a policy to an IAM role, granting necessary permissions for S3 access.

- **AWS IAM Policy (`aws_iam_policy.s3_access`)**: Defines an IAM policy for Databricks to access a specific S3 bucket, with a descriptive policy document.

- **S3 Bucket Module (`module.bucket`)**: Conditionally creates an S3 bucket based on the `create_bucket` variable.

- **Local Variables**: Defines several local variables for bucket ARN, bucket name, S3 URL, and KMS ARN, adapting to whether the bucket is created within the module or pre-existing.

- **AWS IAM Policy Document (`data.aws_iam_policy_document.s3_access_document`)**: Specifies the policy document for S3 access, including various S3 actions and resources.

- **AWS S3 Object (`aws_s3_object.access_test`)**: Optionally creates a test object in the S3 bucket to validate access.

- **Time Sleep Resource (`time_sleep.policy_propagation`)**: Ensures that IAM policy attachment and policy creation are properly propagated.

- **Databricks External Location (`databricks_external_location.this`)**: Configures an external location in Databricks with the specified S3 URL and storage credentials.

- **Databricks Grants for Read and Write Access (`databricks_grants.read_write_grants`)**: Sets up grants for different roles (admin, engineer, scientist, user) based on a `READ_WRITE` permission mode, with dynamic grant handling for additional specified privileges.

- **Databricks Grants for Read-Only Access (`databricks_grants.read_only`)**: Similar to read-write grants but tailored for a `READ_ONLY` permission mode, granting only `READ_FILES` privilege.

This configuration emphasizes security and flexibility, offering conditional resource creation and detailed access control for Databricks external locations in AWS environments.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | ../storage_bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.s3_access_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_object.access_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [databricks_external_location.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) | resource |
| [databricks_grants.read_only](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_grants.read_write_grants](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [time_sleep.policy_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.s3_access_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [databricks_current_user.current_user](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/current_user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `any` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `"Managed by Terraform"` | no |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create a bucket for the external location | `bool` | `true` | no |
| <a name="input_extra_grants"></a> [extra\_grants](#input\_extra\_grants) | n/a | <pre>list(object({<br>    permissions = list(string)<br>    principal   = string<br>  }))</pre> | `[]` | no |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn) | ARN of the KMS key to used for the external location. Required if create\_bucket is false | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the external location | `any` | n/a | yes |
| <a name="input_permission_mode"></a> [permission\_mode](#input\_permission\_mode) | Can be READ\_ONLY or READ\_WRITE | `string` | `"READ_WRITE"` | no |
| <a name="input_role_prefix"></a> [role\_prefix](#input\_role\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Name of the S3 bucket to use for the external location. Required if create\_bucket is false | `any` | `null` | no |
| <a name="input_storage_credential_iam_role"></a> [storage\_credential\_iam\_role](#input\_storage\_credential\_iam\_role) | Name of the IAM role to use for storage credentials. Module will attach permissions to this role. | `string` | n/a | yes |
| <a name="input_storage_credential_name"></a> [storage\_credential\_name](#input\_storage\_credential\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | n/a |
| <a name="output_external_location_id"></a> [external\_location\_id](#output\_external\_location\_id) | n/a |
| <a name="output_external_location_name"></a> [external\_location\_name](#output\_external\_location\_name) | n/a |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | n/a |
<!-- END_TF_DOCS -->
