variable "profile" {
  default = "dtcloud-shared-services"
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
  default = "dtcloud-shared-services"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "shared"
    Moniker     = "dtcloud"
    Application = "shared"
    Product     = "shared-services"
    Script      = "Terraform"
    ProjectID   = "dtcloud-shared-services"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "Connected-To"
  }
}
