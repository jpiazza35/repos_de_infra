## Fivetran
This module deploys the necessary modules related to the Fivetran integration.
Those are:
* Private Link
* Network Load Balancer
* Lambda

Once the terraform is applied the Lambda needs to be run manually unless the databases have been migrated to RDS upon which the SNS topic to trigger the lambda that is in this module as well (just commented out) should be deployed too.

## Notion Documentation
The notion documentation can be found [here](https://www.notion.so/cliniciannexus/Fivetran-84b5eb9247214ac0b931495214e1311a)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.23.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//lambda | 1.0.111 |
| <a name="module_nlb"></a> [nlb](#module\_nlb) | git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//lb | 1.0.112 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_vpc_endpoint_service.fivetran](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Application | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_fivetran_aws_account_id"></a> [fivetran\_aws\_account\_id](#input\_fivetran\_aws\_account\_id) | Fivetran AWS Account ID | `string` | n/a | yes |
| <a name="input_fivetran_cidr"></a> [fivetran\_cidr](#input\_fivetran\_cidr) | Fivetran CIDR | `string` | n/a | yes |
| <a name="input_lambda"></a> [lambda](#input\_lambda) | Lambda | <pre>object({<br>    function_name        = string<br>    description          = string<br>    handler              = string<br>    runtime_version      = string<br>    architectures        = string<br>    timeout              = number<br>    memory_size          = number<br>    ephemeral_storage    = number<br>    requirementsfilename = string<br>    codefilename         = string<br>    working_dir          = string<br>    variables            = map(string)<br>  })</pre> | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | n/a | <pre>map(object({<br>    listener = object({<br>      port             = string<br>      protocol         = string<br>      acm_arn          = optional(string)<br>      target_group_arn = optional(string)<br>      action_type      = string<br>      tags             = optional(map(any))<br>    })<br>    target_group = object({<br>      name_prefix                        = string<br>      vpc_id                             = optional(string)<br>      protocol                           = string<br>      port                               = number<br>      deregistration_delay               = number<br>      target_type                        = string<br>      load_balancing_cross_zone_enabled  = string<br>      lambda_multi_value_headers_enabled = bool<br>      protocol_version                   = string<br>      health_check = object({<br>        enabled             = bool<br>        healthy_threshold   = number<br>        interval            = number<br>        matcher             = string<br>        path                = string<br>        port                = number<br>        protocol            = string<br>        timeout             = number<br>        unhealthy_threshold = number<br>      })<br>      tags = optional(map(any))<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(any)` | n/a | yes |
| <a name="input_target_db_instance_ids"></a> [target\_db\_instance\_ids](#input\_target\_db\_instance\_ids) | List the db\_instances ids that will trigger the lambda function | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
