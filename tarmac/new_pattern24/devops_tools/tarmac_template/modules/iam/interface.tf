variable "s3_bucket_distribution" {
  description = "distribution s3 bucket"
}

variable "s3_bucket" {
  description = "s3 bucket"
}
variable "s3_bucket_log" {
  description = "s3 bucket log"
}

variable "automation_user_name" {
  description = "Name of user"
  type        = string
  default     = "dev-automation"
}

variable "automation_user_path" {
  description = "User path"
  type        = string
  default     = "/"
}

variable "instance_secret_manager_name" {
  description = "Instance rol name for access secret manager"
  type        = string
  default     = "ec2-secret-manager"
}

variable "instance_secret_manager_policy_arn" {
  description = "Policy arn for secret manager access"
  type        = string
  default     = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

variable "redis_consumer_user_name" {
  description = "Redis consumer user name"
  type        = string
  default     = "redis-consumer"
}

variable "redis_consumer_user_path" {
  description = "User path"
  type        = string
  default     = "/"
}

variable "datalake_bucket" {
  description = "s3 datalake bucket"
}

variable "s3_bucket_scripts" {
  description = "s3_bucket_scripts"
}

#variable "load_balancer_bucket_log" {
#  description = "Load balancer bucket"
#}

#variable "load_balancer_bucket_log_name" {
#  description = "Load balancer bucket log name for policy" 
#}
#variable "load_balancer_arn" {
#  description = "Load balancer arn"
#}
#variable "load_balancer_account_id" {
#  description = "root account id for elb " 
#https://docs.aws.amazon.com/en_us/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
#}
#variable "load_balancer_bucket_log_policy_name" {
#  description = "load balancer bucket log policy name"
#}