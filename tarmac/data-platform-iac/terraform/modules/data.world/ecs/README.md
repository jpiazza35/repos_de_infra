<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.ecr_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-policy-SM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-log-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs-task-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecs_task_definition.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_properties"></a> [properties](#input\_properties) | n/a | <pre>object({<br>    name = string<br>    ecr  = object({<br>      image_tag_mutability = string<br>      image_scanning       = object({<br>        scan_on_push = bool<br>      })<br>      lifecycle_policy = object({<br>        description            = string<br>        action_type            = string<br>        selection_tag_status   = string<br>        selection_count_type   = string<br>        selection_count_number = number<br>      })<br>    })<br>    ecs = object({<br>      containerinsights_enable = string<br>      security_group_rules = object({<br>        egress = list(object({<br>          from_port = number<br>          to_port = number<br>          protocol = string<br>          cidr_blocks = list(string)<br>          self = bool<br>        }))<br>        ingress = list(object({<br>          from_port = number<br>          to_port = number<br>          protocol = string<br>          cidr_blocks = list(string)<br>          self = bool<br>        }))<br>      })<br>      services                 = map(object({<br>        service                = string<br>        name                   = string<br>        cpu                    = number<br>        memory                 = number<br>        max_capacity           = number<br>        min_capacity           = number<br>        desired_count          = number<br>        enable_execute_command = bool<br>        taskDefinitionValues   = object({<br>          image          = string<br>          container_name = string<br>          container_port = number<br>          host_port      = number<br>          awslogs-region = string<br>          awslogs-group  = string<br>          portMappings   = string<br>        })<br>      }))<br>    })<br>    vpc_id                = string<br>    environment           = string<br>    product               = string<br>    container_definitions = string<br>    private_subnets       = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_security_group_id"></a> [aws\_security\_group\_id](#output\_aws\_security\_group\_id) | n/a |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_ecs_container_id"></a> [ecs\_container\_id](#output\_ecs\_container\_id) | n/a |
<!-- END_TF_DOCS -->
