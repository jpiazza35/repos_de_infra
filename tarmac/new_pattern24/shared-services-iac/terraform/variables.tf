### GITHUB OIDC ###
variable "attach_admin_policy" {
  description = "Flag to enable/disable the attachment of the AdministratorAccess policy."
  type        = bool
}

variable "attach_read_only_policy" {
  description = "Flag to enable/disable the attachment of the ReadOnly policy."
  type        = bool
}

variable "create_oidc_provider" {
  description = "Flag to enable/disable the creation of the GitHub OIDC provider."
  type        = bool
}

variable "enabled" {
  description = "Flag to enable/disable the creation of resources."
  type        = bool
}

variable "force_detach_policies" {
  description = "Flag to force detachment of policies attached to the IAM role."
  type        = bool
}

variable "github_repositories" {
  description = "List of GitHub organization/repository names authorized to assume the role."
  type        = list(string)

  validation {
    // Ensures each element of github_repositories list matches the
    // organization/repository format used by GitHub.
    condition = length([
      for repo in var.github_repositories : 1
      if length(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+[*]?|\\*)$", repo)) > 0
    ]) == length(var.github_repositories)
    error_message = "Repositories must be specified in the organization/repository format."
  }
}

variable "eks_provider_urls" {
  description = "List of EKS OIDC URLs authorized to assume the role."
  type        = list(string)
}

variable "iam_role_name" {
  default     = ""
  description = "Name of the IAM role to be created. This will be assumable by GitHub."
  type        = string
}

variable "iam_role_path" {
  description = "Path under which to create IAM role."
  type        = string
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the permissions boundary to be used by the IAM role."
  type        = string
}

variable "iam_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the IAM role."
  type        = list(string)
}

variable "iam_role_inline_policies" {
  description = "Inline policies map with policy name as key and json as value."
  type        = map(string)
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds."
  type        = number

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Maximum session duration must be between 3600 and 43200 seconds."
  }
}

### Common ###
variable "tags" {
  description = "Map of tags to be applied to all resources."
  type        = map(string)
}

variable "app" {
  description = "Application this Github OIDC role is being configured for"
  type        = string
}

variable "env" {
  description = "Environment the AWS Account this role is being configured in"
  type        = string
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
}
### Backend/Prereqs ###
variable "dynamodb_name" {}

variable "bucket_name" {}

### ecs ###

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  default     = "LATEST"
  type        = string
}

variable "task_container_image" {
  description = "The image used to start a container."
  type        = string
}

variable "desired_count" {
  description = "The number of instances of the task definitions to place and keep running."
  default     = 1
  type        = number
}

variable "task_container_assign_public_ip" {
  description = "Assigned public IP to the container."
  default     = false
  type        = bool
}

variable "task_container_port" {
  description = "The port number on the container that is bound to the user-specified or automatically assigned host port"
  type        = number
}

variable "task_host_port" {
  description = "The port number on the container instance to reserve for your container."
  type        = number
  default     = 0
}

variable "task_container_protocol" {
  description = "Protocol that the container exposes."
  default     = "HTTP"
  type        = string
}

variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task."
  default     = 256
  type        = number
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the task."
  default     = 512
  type        = number
}

variable "task_definition_ephemeral_storage" {
  description = "The total amount, in GiB, of ephemeral storage to set for the task."
  default     = 0
  type        = number
}

variable "task_container_command" {
  description = "The command that is passed to the container."
  default     = []
  type        = list(string)
}

variable "task_container_entrypoint" {
  description = "The entrypoint that is passed to the container."
  default     = []
  type        = list(string)
}

variable "task_container_environment" {
  description = "The environment variables to pass to a container."
  default     = {}
  type        = map(string)
}

variable "task_container_environment_files" {
  description = "The environment variable files (s3 object arns) to pass to a container. Files must use .env file extension."
  default     = []
  type        = list(string)
}

variable "task_container_secrets" {
  description = "The secrets variables to pass to a container."
  default     = null
  type        = list(map(string))
}

variable "log_retention_in_days" {
  description = "Number of days the logs will be retained in CloudWatch."
  default     = 30
  type        = number
}

variable "health_check" {
  description = "A health block containing health check settings for the target group. Overrides the defaults."
  type        = map(string)
}

variable "health_check_grace_period_seconds" {
  default     = 300
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers."
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  default     = 50
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
}

variable "deployment_maximum_percent" {
  default     = 200
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment"
  type        = number
}

variable "deployment_controller_type" {
  default     = "ECS"
  type        = string
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL. Default: ECS."
}

variable "enable_deployment_circuit_breaker" {
  default     = "false"
  type        = bool
  description = "Whether to enable the deployment circuit breaker logic for the service."
}

variable "enable_deployment_circuit_breaker_rollback" {
  default     = "false"
  type        = bool
  description = "Whether to enable Amazon ECS to roll back the service if a service deployment fails. If rollback is enabled, when a service deployment fails, the service is rolled back to the last deployment that completed successfully."
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
variable "repository_credentials" {
  default     = ""
  description = "name or ARN of a secrets manager secret (arn:aws:secretsmanager:region:aws_account_id:secret:secret_name)"
  type        = string
}

variable "repository_credentials_kms_key" {
  default     = "alias/aws/secretsmanager"
  description = "key id, key ARN, alias name or alias ARN of the key that encrypted the repository credentials"
  type        = string
}

variable "create_repository_credentials_iam_policy" {
  default     = false
  description = "Set to true if you are specifying `repository_credentials` variable, it will attach IAM policy with necessary permissions to task role."
  type        = bool
}

variable "service_registry_arn" {
  default     = ""
  description = "ARN of aws_service_discovery_service resource"
  type        = string
}

variable "propagate_tags" {
  type        = string
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  default     = "SERVICE"
}

variable "target_groups" {
  type        = any
  default     = []
  description = "The name of the target groups to associate with ecs service"
}

variable "load_balanced" {
  type        = bool
  default     = true
  description = "Whether the task should be loadbalanced."
}

variable "logs_kms_key" {
  type        = string
  description = "The KMS key ARN to use to encrypt container logs."
  default     = ""
}

variable "capacity_provider_strategy" {
  type        = list(any)
  description = "(Optional) The capacity_provider_strategy configuration block. This is a list of maps, where each map should contain \"capacity_provider \", \"weight\" and \"base\""
  default     = []
}

variable "placement_constraints" {
  type        = list(any)
  description = "(Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
  default     = []
}

variable "proxy_configuration" {
  type        = list(any)
  description = "(Optional) The proxy configuration details for the App Mesh proxy. This is a list of maps, where each map should contain \"container_name\", \"properties\" and \"type\""
  default     = []
}

variable "volume" {
  description = "(Optional) A set of volume blocks that containers in your task may use. This is a list of maps, where each map should contain \"name\", \"host_path\", \"docker_volume_configuration\" and \"efs_volume_configuration\". Full set of options can be found at https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html"
  default     = []
  type        = list(any)
}

variable "task_health_command" {
  type        = list(string)
  description = "A string array representing the command that the container runs to determine if it is healthy."
  default     = null
}

variable "task_health_check" {
  type        = map(number)
  description = "An optional healthcheck definition for the task"
  default     = null
}

variable "task_container_cpu" {
  description = "Amount of CPU to reserve for the container."
  default     = 256
  type        = number
}

variable "task_container_memory" {
  description = "The hard limit (in MiB) of memory for the container."
  default     = null
  type        = number
}

variable "task_container_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container."
  default     = null
  type        = number
}

variable "task_container_working_directory" {
  description = "The working directory to run commands inside the container."
  default     = ""
  type        = string
}

variable "task_start_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before giving up on resolving dependencies for a container. If this parameter is not specified, the default value of 3 minutes is used (fargate)."
  default     = null
}

variable "task_stop_timeout" {
  type        = number
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own. The max stop timeout value is 120 seconds and if the parameter is not specified, the default value of 30 seconds is used."
  default     = null
}

variable "task_mount_points" {
  description = "The mount points for data volumes in your container. Each object inside the list requires \"sourceVolume\", \"containerPath\" and \"readOnly\". For more information see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html "
  type        = list(object({ sourceVolume = string, containerPath = string, readOnly = bool }))
  default     = null
}

variable "task_pseudo_terminal" {
  type        = bool
  description = "Allocate TTY in the container"
  default     = null
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. myimage:latest), roll Fargate tasks onto a newer platform version."
  default     = false
}

variable "wait_for_steady_state" {
  type        = bool
  description = "If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  default     = false
}

variable "enable_execute_command" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = true
}

variable "enable_ecs_managed_tags" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  default     = true
}

variable "operating_system_family" {
  description = "The operating system family for the task."
  default     = "LINUX"
  type        = string
}

variable "cpu_architecture" {
  description = "cpu architecture for the task"
  default     = "X86_64"
  type        = string
}

variable "readonlyRootFilesystem" {
  default     = false
  description = "When this parameter is true, the container is given read-only access to its root file system"
  type        = bool
}

#### phpIPAM
variable "cidr_ranges" {
  description = "The CIDR Ranges available to AWS"
}

variable "azure_cidr_ranges" {
  description = "The CIDR Ranges available to Azure"
}

variable "full_vpcs" {
  description = "Used VPC CIDRS"
}

## Vault Management
variable "paths" {
  description = "KV Secret paths"
}

variable "k8s_serviceaccount" {
  description = "Name of the Kubernetes Service Account for the Vault Auth Injector"
}

variable "k8s_cert_issuer_serviceaccount" {

}

variable "vault_addr" {
  description = "The url for vault"
}

variable "cluster_name" {
  description = "Name of the kubernetes cluster"
}

## Sonatype Artifactory
variable "sonatype_task_container_image" {}
variable "sonatype_task_definition_cpu" {}
variable "sonatype_task_definition_memory" {}
variable "sonatype_task_container_memory" {}
variable "sonatype_task_container_cpu" {}
variable "sonatype_task_container_port" {}
variable "sonatype_task_container_assign_public_ip" {}

variable "sonatype_target_groups" {
  type        = any
  default     = []
  description = "The name of the target groups to associate with ecs service"
}

variable "sonatype_health_check" {
  description = "A health block containing health check settings for the target group. Overrides the defaults."
  type        = map(string)
}

# ## INCIDENT BOT
# variable "incident_bot_task_container_image" {}
# variable "incident_bot_task_definition_cpu" {}
# variable "incident_bot_task_definition_memory" {}
# variable "incident_bot_task_container_memory" {}
# variable "incident_bot_task_container_cpu" {}
# variable "incident_bot_task_container_port" {}
# variable "incident_bot_task_container_assign_public_ip" {}

# variable "incident_bot_target_groups" {
#   type        = any
#   default     = []
#   description = "The name of the target groups to associate with ecs service"
# }

# variable "incident_bot_health_check" {
#   description = "A health block containing health check settings for the target group. Overrides the defaults."
#   type        = map(string)
# }

variable "backend_accounts_ids" {
  type = list(any)
}

variable "backend_dynamodb_table_arn" {
  type = string
}
