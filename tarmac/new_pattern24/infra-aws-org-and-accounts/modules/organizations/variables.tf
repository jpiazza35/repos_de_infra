variable "region" {
  type        = string
  description = "The region to create resources in."
}

variable "description" {
  type    = string
  default = "Guardrails applied to an organization"
}

variable "dev_accounts_org_unit" {
  type        = string
  description = "The name of the AWS Organizations org. unit where we will create developer accounts."
}