

variable "env" {}

variable "name" {}

variable "enable_self_trust" {
  type        = bool
  default     = false
  description = "Enable self trust for the role. This must be false on first apply, then true on subsequent applies."
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}
