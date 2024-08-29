variable "region" {
  default     = "us-east-1"
  description = "The region to create resources in."
  type        = string
}

variable "dev_accounts_org_unit" {
  default     = "Individuals"
  description = "The name of the AWS Organizations org. unit where we will create developer accounts."
  type        = string
}