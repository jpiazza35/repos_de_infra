
variable "env" {}

variable "service_principal_application_id" {
  type = string
}

variable "service_principal_name" {}

variable "lifetime_seconds" {
  type    = number
  default = null
}

variable "comment" {
  type    = string
  default = null
}
