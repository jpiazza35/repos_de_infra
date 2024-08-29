# BigEye Deployment Module

The BigEye deployment module will deploy an EC2 instance, load it with the necessary parameters and start the bigeye agent.

### Secrets requrired to be present at the bigeye_mtls_secret_name path provided:
* agent_yaml_b64
* bigeye_pem_b64
* bigeye_workflows_ca_pem_b64
* company_pem_b64
* company_uuid
* docker_compose_yaml_b64
* docker_password
* mtls_ca_conf_b64
* mtls_ca_key_b64
* mtls_ca_pem_b64
* mtls_conf_b64
* mtls_key_b64
* mtls_pem_b64
* private_key_b64
* private_pem_b64

### Secrets required to be present at the bigeye_agent_config_secret_name path provided:
* host
* username
* password
* databaseName

Note that in the case of deploying a BigEye agent for databricks:
* username = httpPath
* password = service principal access token
* databaseName = _leave this value empty_

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.12.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bigeye_ec2"></a> [bigeye\_ec2](#module\_bigeye\_ec2) | ./modules/ec2 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_iam_role.ec2_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.user_data_bigeye_databricks](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_identifier"></a> [agent\_identifier](#input\_agent\_identifier) | The identifier of the agent. This value must be unique for each agent. Additionally, this is the value that will be used to identify the agent in the Bigeye UI. | `string` | n/a | yes |
| <a name="input_agent_type"></a> [agent\_type](#input\_agent\_type) | The type of the agent. Allowed_values are awsathena, mysql, oracle, postgresql, presto, redshift, sap, snowflake, spark, sqlserver, synapse, trino, vertica | `string` | n/a | yes |
| <a name="input_ami_to_find"></a> [ami\_to\_find](#input\_ami\_to\_find) | AMI name to be used in data\_source search. If left blank, Amazon Linux 2 will be used | `map` | <pre>{<br>  "name": "amzn2-ami-hvm-2.0.20230727.0-x86_64-ebs",<br>  "owner": "137112412989"<br>}</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the EC2 instance | `string` | `"us-east-1"` | no |
| <a name="input_bigeye_agent_config_secret_name"></a> [bigeye\_agent\_config\_secret\_name](#input\_bigeye\_agent\_config\_secret\_name) | Path to HC Vault secret where the agent.yaml parameters are stored | `string` | n/a | yes |
| <a name="input_bigeye_mtls_secret_name"></a> [bigeye\_mtls\_secret\_name](#input\_bigeye\_mtls\_secret\_name) | Path to HC Vault secret where all the mtls secrets are stored | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment in which to deploy the EC2 instance | `string` | n/a | yes |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | The name of the IAM instance profile to be attached to the EC2 instance | `string` | `"vault_aws_auth"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `"primary-vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
