variable "profile" {
  default = "__________"
}

variable "project" {
  default = "__________"
}

variable "region" {
  default = "__________"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(string)

  default = {
    costcentre = ""
    env        = ""
    repository = "https://github.com/_________________"
    script     = "Terraform"
    service    = "ecs-_________"
    vpc        = "main"
    act        = "prod"
  }
}

terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket         = "_______________________"
    dynamodb_table = "_______________________"
    encrypt        = "true"
    key            = "_______________________"
    profile        = "_______________________"
    region         = "_______________________"
  }
}

