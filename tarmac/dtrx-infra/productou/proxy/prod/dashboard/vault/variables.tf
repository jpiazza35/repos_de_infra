variable "profile" {
  default = "dtcloud-proxy-prod"
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
  default = "dtcloud-proxy-prod"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "prod"
    Moniker     = "dtcloud"
    Product     = "proxy"
    Application = "dashboard"
    Service     = "vault"
    Script      = "Terraform"
    ProjectID   = "dtcloud-infra"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "DSS"
  }
}
