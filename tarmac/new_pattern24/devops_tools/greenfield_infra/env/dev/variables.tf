variable "projectname" {
  default = "greenfield"
}

variable "profile" {
  default = "tarmac"
}

variable "region" {
  default = "sa-east-1"
}

variable "cidr_block" {
  default = "10.9.0.0/18"
}

variable "env" {
  default = "dev"
}

variable "rds_password" {
  type = string
}

variable "name" {
  default = "greenfieldrds"
}

variable "rootdomain" {
  default = "greenfield.uy"
}

# Tags Array ( referenced as ${var.tags["tagname"]} )
variable "tags" {
  type = map(any)

  default = {
    Name        = "greenfield"
    projectname = "greenfield"
    act         = "dev"
    costcentre  = ""
    env         = "dev"
    repository  = "GH_REPO_URL"
    script      = "Terraform"
    service     = "greenfield-app"
    vpc         = "main"
  }
}