variable "profile" {
  default = "dtcloud-root"
  type    = string
}

variable "region" {
  default = "eu-central-1"
  type    = string
}

variable "account_alias" {
  type    = string
  default = "dtcloud-root"
}

variable "logging_aws_account_id" {
  default = "044888517122"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Environment = "root"
    Moniker     = "root"
    Application = "root"
    Product     = "root"
    Application = "dashboard"
    Service     = "root"
    Script      = "Terraform"
    ProjectID   = "dtcloud-infra"
    Repository  = "https://github.com/tarmac/dtcloud-infra/"
    PCI         = "Connected-To"
  }
}
