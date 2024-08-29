variable "service_principal_application_ids" {
  type        = list(string)
  description = "Service principals that receive CAN_USE permissions on tokens."
}

variable "user_group_names" {
  type        = list(string)
  description = "Groups that receive CAN_USE permissions on tokens."
}
