
variable "public_dns" {
  type = string
}

variable "private_dns" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
}

variable "region" {
}

#ECS variables start here

variable "name" {
  type        = string
  description = "The name of ecs service."
}

variable "container_name" {
  type        = string
  description = "The name of the container to associate with the load balancer (as it appears in a container definition)."
}

variable "container_port" {
  type        = string
  description = "The port on the container to associate with the load balancer."
}

variable "cluster" {
  type        = string
  description = "ARN of an ECS cluster."
}

variable "container_definitions" {
  type        = string
  description = "A list of valid container definitions provided as a single valid JSON document."
}

variable "desired_count" {
  default     = 0
  type        = string
  description = "The number of instances of the task definition to place and keep running."
}

variable "deployment_maximum_percent" {
  default     = 200
  type        = string
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
}

variable "deployment_minimum_healthy_percent" {
  default     = 100
  type        = string
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
}

variable "deployment_controller_type" {
  default     = "ECS"
  type        = string
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS."
}

variable "assign_public_ip" {
  default     = false
  type        = string
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false."
}

variable "health_check_grace_period_seconds" {
  default     = 60
  type        = string
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200."
}

variable "ingress_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = list(string)
  description = "List of Ingress CIDR blocks."
}

variable "cpu" {
  default     = "256"
  type        = string
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = "512"
  type        = string
  description = "The amount (in MiB) of memory used by the task."
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  type        = list(string)
  description = "A set of launch types required by the task. The valid values are EC2 and FARGATE."
}

variable "enabled" {
  default     = true
  type        = string
  description = "Set to false to prevent the module from creating anything."
}

variable "s3_backend_bucket_name" {
  default     = ""
  type        = string
  description = "The s3 bucket name for the terraform state files."
}