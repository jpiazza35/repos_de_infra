variable "vpc_id" {}

variable "tags" {
  type = map(string)
}

variable "rds_password" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "name" {
  type = string
}

variable "subnet_ids" {
  default = ""
}
variable "ecs_security_group_id" {
  default = ""
}