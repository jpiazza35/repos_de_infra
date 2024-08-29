variable "profile" {
  default = "dtcloud-logging-monitoring"
  type    = string
}

variable "region" {
  default = "eu-central-1"
  type    = string
}

#to be defined with dtcloud
#variable "cidr_block" {
#  default = " "
#}

#to be defined with dtcloud
# variable "product_name" {
#   default = " "
#   type    = string
# }

variable "account_alias" {
  type    = string
  default = "dtcloud-logging-monitoring"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "core"
    Moniker     = "dtcloud"
    Application = "logging"
    Product     = "core"
    Script      = "Terraform"
    ProjectID   = "dtcloud-infra"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "Connected-To"
  }
}
