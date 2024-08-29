
variable "cluster_id" {}

variable "workspace" {
  validation {
    error_message = "Must by 'sdlc', 'preview' or 'prod'"
    condition     = contains(["sdlc", "preview", "prod"], var.workspace)
  }
}

locals {
  role_prefixes = {
    sdlc    = "db_sdlc"
    preview = "db_preview"
    prod    = "db_prod_ws"
  }
}

variable "additional_group_permissions" {
  type = list(object({
    permission_level = string
    group_name       = string
  }))
  validation {
    error_message = "Permission level must be one of [CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE]"
    condition = alltrue([
      for permission in var.additional_group_permissions : contains(
        [
          "CAN_ATTACH_TO",
          "CAN_RESTART",
          "CAN_MANAGE"
        ], permission.permission_level
      )
    ])
  }
  default = []
}

variable "additional_service_principal_permissions" {
  type = list(object({
    permission_level       = string
    service_principal_name = string
  }))
  validation {
    error_message = "Permission level must be one of CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE"
    condition = alltrue([
      for permission in var.additional_service_principal_permissions : contains(
        [
          "CAN_ATTACH_TO",
          "CAN_RESTART",
          "CAN_MANAGE"
        ], permission.permission_level
      )
    ])
  }
  default = []
}

variable "additional_user_permissions" {
  type = list(object({
    permission_level = string
    user_name        = string
  }))
  validation {
    error_message = "Permission level must be one of CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE"
    condition = alltrue([
      for permission in var.additional_user_permissions : contains(
        [
          "CAN_ATTACH_TO",
          "CAN_RESTART",
          "CAN_MANAGE"
        ], permission.permission_level
      )
    ])
  }
  default = []
}