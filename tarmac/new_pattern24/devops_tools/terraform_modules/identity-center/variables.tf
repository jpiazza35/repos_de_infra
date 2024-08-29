variable "tags" {
  type = map(any)

  default = {
    Environment = "root"
    Script      = "Managed by Terraform"
    Repository  = ""
  }
}

variable "profile" {
  default = ""
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "dev_acc_id" {
  default = ""
}

variable "prod_acc_id" {
  default = ""
}

variable "admin_pset_name" {
  default = "AdminPermissionSet"
}

variable "readonly_pset_name" {
  default = "ReadOnlyPermissionSet"
}

variable "billing_pset_name" {
  default = "BillingPermissionSet"
}