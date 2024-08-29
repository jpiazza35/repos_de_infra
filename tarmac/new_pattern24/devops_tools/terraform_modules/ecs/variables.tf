variable "cluster_arn" {
  type        = string
  description = "The ECS cluster ARN."
}

variable "cluster_name" {
  type        = string
  description = "The ECS cluster Name."
}

variable "ecs_service_count" {
  type = number
}

variable "ds_dns_name" {
  type        = string
  description = "The ds name for the DNS zone."
}

variable "shared_ecs_service_client_uuids" {
  type        = list(string)
  description = "The CN UUIDs for the clients using the shared ECS service."
}

variable "client_ecs_services_client_uuids" {
  type        = list(string)
  description = "The CN UUIDs for the clients using their own ECS service."
}

variable "client_subdomains" {
  type        = list(string)
  description = "The clients API GWs subdomains."
}

variable "create_internal_lb" {
  type        = bool
  description = "Whether to create internal ALB and target group resources."
}

variable "create_postgresql_sg_rule" {
  type        = bool
  description = "Whether to add access to RDS PostgreSQL - security group rule."
}

variable "create_redis_sg_rule" {
  type        = bool
  description = "Whether to add access to Elasticache Redis - security group rule."
}

variable "create_opensearch_sg_rule" {
  type        = bool
  description = "Whether to add access to Opensearch - security group rule."
}

variable "create_alb_public_listener_rule" {
  type        = bool
  description = "Whether to create the public listener rule in the internal ALB."
}

variable "is_admin" {
  type        = bool
  default     = false
  description = "Conditional var used in resources/parameters that need admin or not logic."
}

variable "create_alb_ds_listener_rule" {
  type        = bool
  description = "Whether to create the DS listener rule in the internal ALB."
}

variable "create_rds_iam_auth" {
  type        = bool
  description = "Whether to create the RDS IAM DB auth resources (policy and attachment)."
}

variable "create_acquiring_iam_sg_rule" {
  type        = bool
  description = "Whether to create the ECS egress sg rule to acquiring IAM server."
}

variable "create_egress_internet" {
  type        = bool
  description = "Whether to create the ECS egress sg rule to the world - only applied on temp and test."
}

variable "create_egress_riskshield" {
  type        = bool
  description = "Whether to create the ECS egress sg rule to Riskshield Service - only applied on ECEA."
}

variable "create_da_cli_efs" {
  type        = bool
  default     = false
  description = "Whether to create the ECS task definition and EFS volume - only applied to da-cli app."
}

variable "da_efs_posix_uid_gid" {
  type        = string
  default     = "1818"
  description = "The user-id/group-id value used for the DA EFS posix permission configuration"
}

variable "da_efs_posix_permission" {
  type        = string
  default     = "0733"
  description = "The permission value used for the da EFS posix permission configuration"
}

variable "create_preparation_handler" {
  type        = bool
  default     = false
  description = "Whether to create the 3ds-server-preparation-handler resources."
}

variable "create_jump_host_sg_rule" {
  type        = bool
  description = "Wheater to create Ingress rule from the Jump hosts to the ECS containers"
  default     = false
}

variable "create_clients_ecs_resources" {
  type        = bool
  description = "Whether to client related ECS resources."
}

variable "is_example_server" {
  type        = bool
  default     = false
  description = "Check if terraform running is for 3ds-server."
}

variable "env_public_dns_id" {
  type        = string
  description = "The ID of the public DNS account/environment zone(s)."
}

variable "env_public_dns_name" {
  type        = string
  description = "The name of the public DNS account/environment zone(s)."
}

variable "internal_dns_id" {
  type        = string
  description = "The private Route53 zone ID."
}

variable "internal_dns_name" {
  type        = string
  description = "The private Route53 zone Name."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of all private subnets IDs."
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "A list of all private subnets CIDR blocks."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of all public subnets IDs."
}

variable "s3_vpc_endpoint_prefix_id" {
  type = string
}

variable "nca_acquiring_iam_ip_address" {
  type        = string
  description = "The IP address of the acquiring IAM server."
}

variable "cw_log_groups_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used to encrypt Cloudwatch log groups."
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "vpc_endpoints_sg_id" {
  description = "The VPC endpoints security group ID."
}

variable "i_alb_listener_rule_priority" {
  description = "The priority of the internal ALB listener rule."
}

variable "i_alb_public_listener_rule_priority" {
  description = "The priority of the internal ALB public listener rule."
}

variable "i_alb_clients_public_listener_rule_priority" {
  description = "The priority of the internal ALB public clients listener rules."

}

variable "i_alb_ds_listener_rule_priority" {
  description = "The priority of the internal ALB DS cards listener rule for the shared ECS service."
}

variable "i_alb_ds_clients_listener_rule_priority" {
  description = "The priority of the internal ALB DS cards listener rule per specific client."
}

variable "assume_ecs_role_document" {
}

variable "ecs_task_execution_policy" {
}

variable "listener" {
  type    = list(string)
  default = []
}

variable "resources" {
  type = list(string)

  default = [
    "*",
  ]
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "The AWS account VPC ID."
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "The AWS account VPC CIDR IP range."
}

variable "temp_vpc_cidr_block" {
  type        = string
  description = "The temp AWS account VPC CIDR IP range."
}

variable "jump_host_cidr_block" {
  type        = string
  description = "The PP Jump Host CIDR IP range."
}

variable "vpc_name" {
  default = ""
}

variable "region" {
}

variable "target_group_port" {
  default     = "8080"
  description = "The target group port."
}

variable "target_group_protocol" {
  default     = "HTTP"
  description = "The target group protocol."
  type        = string
}

variable "target_group_health_check_path" {
  default     = "/actuator/health"
  description = "The target group health check path."
  type        = string
}

variable "i_alb_sg_id" {
  type        = string
  description = "The internal ALB security group ID."
}

variable "i_alb_sg_name" {
  type        = string
  description = "The internal ALB security group name."
}

variable "i_alb_zone_id" {
  type        = string
  description = "The internal ALB DNS Zone ID."
}

variable "i_alb_dns_name" {
  type        = string
  description = "The internal ALB DNS name."
}

variable "i_alb_listener_arn" {
  type        = string
  description = "The internal ALB listener ARN."
}

variable "i_alb_listener_port" {
  type        = string
  description = "The internal ALB listener port."
}

variable "secrets_vpc_endpoint_id" {
  type        = string
  description = "The AWS SecretsManager VPC endpoint ID."
}

variable "s3_vpc_endpoint_id" {
  type        = string
  description = "The AWS S3 VPC endpoint ID."
}

variable "db_account_arn" {
  type        = string
  description = "The db account arn to use for the RDS IAM authentication policy."
}

variable "db_postgresql_sg_id" {
  type        = string
  description = "The RDS postgresql security group ID."
}

variable "lb_deletion_protection" {
  type        = string
  description = "Sets the deletion protection on the internal ALB."
}

variable "shared_services_aws_account_id" {
  description = "The Shared Services AWS account ID."
}

#ECS variables start here

variable "container_name" {
  type        = string
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)."
}

variable "container_port" {
  type        = string
  description = "The port on the container to associate with the load balancer."
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "desired_count" {
  type        = string
  default     = 0
  description = "The number of instances of the task definition to place and keep running."
}

variable "deployment_maximum_percent" {
  type        = string
  default     = 200
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

variable "deployment_minimum_healthy_percent" {
  type        = string
  default     = 100
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

variable "deployment_controller_type" {
  type        = string
  default     = "ECS"
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS."
}

variable "assign_public_ip" {
  type        = string
  default     = false
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false."
}

variable "health_check_grace_period_seconds" {
  type        = string
  default     = 60
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200."
}

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "List of Ingress CIDR blocks."
  type        = list(string)
}

variable "cpu" {
  type        = string
  default     = "256"
  description = "The number of cpu units used by the task."
}

variable "memory" {
  type        = string
  default     = "512"
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = list(string)
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}

variable "iam_path" {
  type        = string
  default     = "/"
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "ecs_as_cpu_low_threshold_per" {
  default = "20"
}

variable "ecs_as_cpu_high_threshold_per" {
  default = "80"
}

variable "ecs_as_memory_high_threshold_per" {
  default = "70"
}

variable "asg_max_capacity" {
  type = string
}

variable "asg_min_capacity" {
  type = string
}

variable "profile" {
  type = string
}

variable "cw_agent_server_policy_arn" {
  type        = string
  description = "The ARN of the AWS managed CloudWatchAgentServerPolicy."
}

variable "elasticache_redis_sg_id" {
  type        = string
  description = "The Elasticache Redis security group ID. (from admin redis module)"
}

variable "elasticsearch_sg_id" {
  type        = string
  description = "The Opensearch security group ID. (from admin elk module)"
}

variable "egress_port_to_subnets" {
  default     = "8080"
  type        = string
  description = "Egress port to private subnets"
}

variable "create_lambda_permission" {
  type        = bool
  description = "Whether to create lambda permission"
}

variable "create_cw_metric" {
  type        = bool
  description = "Whether to create cw metrics"
}

variable "create_utilization_autoscaling" {
  type        = bool
  description = "Whether to create the utilization autoscaling."
}

variable "create_scheduled_autoscaling" {
  type        = bool
  description = "Whether to create the scheduled autoscaling."
}

variable "create_ecs_cluster" {
  type        = bool
  default     = false
  description = "Whether to create cluster"
}

variable "create_ecs_service" {
  type        = bool
  description = "Whether to create ecs service"
}

variable "create_ecs_task_definition" {
  type        = bool
  description = "Whether to create ecs task definition."
}

variable "create_secrets_iam" {
  type        = bool
  description = "Whether to create Secrets Manager IAM policies."
}

variable "upload_local_file" {
  type        = bool
  description = "Whether to create local file"
}

variable "create_da_cli_local_file" {
  type        = bool
  default     = false
  description = "Whether to create the local file for da-cli"
}

variable "create_db_seeder_local_file" {
  type        = bool
  default     = false
  description = "Whether to create the local file for db seeder"
}

variable "create_r53_record" {
  type        = bool
  description = "Whether to create route53 record"
}

variable "create_sg_rules" {
  type        = bool
  description = "Whether to create sg rules"
}

variable "create_vpn_sg_rules" {
  type        = bool
  description = "Whether to create sg rules for temporary Open VPN"
}

variable "riskshield_ip" {
  type        = string
  description = "IP Cidr for Riskshield Service"
}

variable "secrets_manager_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret."
  type        = string
}

variable "client_ecs_services_names" {
  type        = list(string)
  description = "The names for the client specific ECS services."
}

variable "shared_ecs_service_client_list" {
  type        = list(string)
  description = "The clients that don't have their own ECS service (using the shared one)."
}

variable "cw_metric_alarms_period" {
  type        = number
  default     = 60
  description = "The period in seconds over which the specified statistic is applied."
}

variable "cw_cpu_metric_alarm_evaluation" {
  type        = number
  description = "The number of periods for the CPU utilization alarm over which data is compared to the specified threshold."
}

variable "cw_memory_metric_alarm_evaluation" {
  type        = number
  description = "The number of periods for the memory utilization alarm over which data is compared to the specified threshold."
}
