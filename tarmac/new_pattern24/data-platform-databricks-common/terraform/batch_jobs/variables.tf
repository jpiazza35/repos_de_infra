variable "batch_jobs" {
  type = map(object({
    username_secret   = string
    password_secret   = string
    database_product  = string
    host_name_secret  = string
    port_number       = number
    database_name     = string
    target_table_list = list(string)
  }))
}

variable "target_catalog" {}

variable "instance_profile_arn" {}

variable "wheel_path" {}
