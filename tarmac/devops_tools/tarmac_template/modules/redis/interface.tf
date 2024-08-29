variable "redis_name" {
  description = "Redis name"
  type        = string
  default     = "redis-cluster"
}
variable "redis_username" {
  description = "Root username"
  type        = string
  default     = "redis"
}
variable "tags" {
  type = map(any)
}
variable "redis_user_acl_name" {
  description = "Redis users acl name"
  type        = string
  default     = "redis-users-acl"
}

variable "redis_node_type" {
  description = "Redis cluster node type"
  type        = string
  default     = "db.t4g.small"
}

variable "redis_num_shards" {
  description = "Number of redis shards"
  type        = number
  default     = 1
}

variable "redis_security_group" {
  description = "Redis security group ids"
  type        = string
  default     = ""
}

variable "redis_snapshot_retention" {
  description = "Snaphot retention limit"
  type        = number
  default     = 7
}

variable "redis_subnet_group_name" {
  description = "Subnet group name"
  type        = string
  default     = "redis-subnet-group"
}

variable "redis_vpc_id" {
  description = "Redis vpc id"
  type        = string
  default     = ""
}

variable "redis_subnet_ids" {
  description = "Redis subnets ids"
  type        = list(string)
  default     = [""]
}

variable "redis_parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = "default.memorydb-redis6"
}

variable "redis_consumer_username" {
  description = "Redis user consumer name"
  type        = string
  default     = "redis-consumer"
}

variable "redis_user_consumer_arn" {
  description = "Redis user consumer arn"
  type        = string
  default     = ""
}

variable "environment" {
  type = string
}