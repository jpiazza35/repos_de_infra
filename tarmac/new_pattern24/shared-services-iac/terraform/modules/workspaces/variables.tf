variable "app" {}

variable "tags" {}

variable "dc_ips" {
  description = "Domain Controller IPs in the same region"
  default = [
    ## using ssdc01 and ssdc02 in us-east-1 for testing
    "10.202.4.68",
    "10.202.4.198"
  ]
}

variable "domain_short_name" {
  default = "sca"
}

variable "domain_name" {
  default = "sca.local"
}

variable "enable_sso" {
  default = false
}

variable "ds_type" {
  description = "Optional - The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD"
  default     = "ADConnector"
}

variable "ds_size" {
  description = "Optional (For SimpleAD and ADConnector types) The size of the directory (Small or Large are accepted values). Large by default."
  default     = "Small"
}

variable "workspaces" {
  description = "Workspaces to be created"
  type = map(object({
    user_name                                 = string
    compute_type_name                         = optional(string) # (Optional) The compute type. For more information, see Amazon WorkSpaces Bundles. Valid values are VALUE, STANDARD, PERFORMANCE, POWER, GRAPHICS, POWERPRO, GRAPHICSPRO, GRAPHICS_G4DN, and GRAPHICSPRO_G4DN.
    compute_os_name                           = optional(string)
    user_volume_size_gib                      = optional(number)
    root_volume_size_gib                      = optional(number)
    running_mode                              = optional(string)
    running_mode_auto_stop_timeout_in_minutes = optional(number)
    })
  )
}

variable "ingress_cidr" {
  description = "CIDR Range that allows access to the workspace"
  default     = "0.0.0.0/0"
}
