variable "profile" {
  default = "dtcloud-infra-code"
  type    = string
}

variable "region" {
  default = "eu-central-1"
  type    = string
}

variable "account_alias" {
  type    = string
  default = "dtcloud-infra-code"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "shared"
    Moniker     = "dtcloud"
    Application = "dtcloud"
    Product     = "infra-code"
    Script      = "Terraform"
    ProjectID   = "dtcloud-infra-code"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "Connected-To"
  }
}
