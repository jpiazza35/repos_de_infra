<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../../modules/data.world/ecs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_scheduler_schedule.trigger_lambda_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [null_resource.install_lambda](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda_archive](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.databricks](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.dataworld-rw-api-token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.prod-ces-db](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.prod-incumbent-db](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.prod-mssql-db](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.prod-redshift](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.prod-tableau](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.slack_webhook](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_properties"></a> [agent\_properties](#input\_agent\_properties) | n/a | <pre>map(object({<br>    name = string<br>    ecr = object({<br>      image_tag_mutability = string<br>      image_scanning = object({<br>        scan_on_push = bool<br>      })<br>      lifecycle_policy = object({<br>        description            = string<br>        action_type            = string<br>        selection_tag_status   = string<br>        selection_count_type   = string<br>        selection_count_number = number<br>      })<br>    })<br>    ecs = object({<br>      containerinsights_enable = string<br>      security_group_rules = object({<br>        egress = list(object({<br>          from_port   = number<br>          to_port     = number<br>          protocol    = string<br>          cidr_blocks = list(string)<br>          self        = bool<br>        }))<br>        ingress = list(object({<br>          from_port   = number<br>          to_port     = number<br>          protocol    = string<br>          cidr_blocks = list(string)<br>          self        = bool<br>        }))<br>      })<br>      services = map(object({<br>        service                = string<br>        name                   = string<br>        cpu                    = number<br>        memory                 = number<br>        max_capacity           = number<br>        min_capacity           = number<br>        desired_count          = number<br>        enable_execute_command = bool<br>        taskDefinitionValues = object({<br>          image_tag      = string<br>          container_name = string<br>          container_port = number<br>          host_port      = number<br>          awslogs-region = string<br>          awslogs-group  = string<br>          portMappings   = string<br>        })<br>      }))<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_common_properties"></a> [common\_properties](#input\_common\_properties) | n/a | <pre>object({<br>    vpc_id      = string<br>    environment = string<br>    env_prefix  = string<br>    product     = string<br>  })</pre> | n/a | yes |
| <a name="input_lambda_properties"></a> [lambda\_properties](#input\_lambda\_properties) | n/a | <pre>object({<br>    function_name     = string<br>    description       = string<br>    handler           = string<br>    architectures     = string<br>    runtime_version   = string<br>    timeout           = number<br>    memory_size       = number<br>    ephemeral_storage = number<br>  })</pre> | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | `"d_data_platform"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container"></a> [container](#output\_container) | n/a |
| <a name="output_ecs_cluster"></a> [ecs\_cluster](#output\_ecs\_cluster) | n/a |
| <a name="output_input"></a> [input](#output\_input) | n/a |
| <a name="output_sec_gr_id"></a> [sec\_gr\_id](#output\_sec\_gr\_id) | n/a |
<!-- END_TF_DOCS -->