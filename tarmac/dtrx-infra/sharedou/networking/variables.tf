variable "profile" {
  default = "dtcloud-networking"
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
  default = "dtcloud-networking"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "shared"
    Moniker     = "dtcloud"
    Application = "networking"
    Product     = "shared"
    Script      = "Terraform"
    ProjectID   = "dtcloud-networking"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "Connected-To"
  }
}
