variable "nexus_user" {}

variable "nexus_password" {}

variable "nexus_url" {
  description = "URL without https://"
}

variable "nexus_base_url" {}

variable "bsr_user" {}

variable "bsr_password" {}

variable "bsr_url" {
  default = "clinician-nexus.buf.dev/gen/python"
}

variable "create_global_script" {
  default     = true
  description = "Whether or not to create a workspace wide init script"
}
