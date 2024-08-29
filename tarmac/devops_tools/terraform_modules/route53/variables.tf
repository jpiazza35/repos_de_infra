variable "create_dns_resources" {
  type        = string
  description = "Whether to create DNS resources or not."
}

variable "create_main_dns_resources" {
  type        = string
  description = "Whether to create the main DNS domain (example-account-cloud-payment.ch) resources (zones, certs, records)."
}

variable "create_apps_dns_resources" {
  type        = string
  description = "Whether to create the DNS resources (zones, certs, records)"
}

variable "create_env_dns_resources" {
  type        = string
  description = "Whether to create the DNS resources (zones, certs, records) per env (temp.*, test.*)."
}

variable "create_ds_dns_resources" {
  type        = string
  default     = false
  description = "Whether to create the DNS resources (zones, certs, records)"
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "vpc_id" {
  description = "The AWS VPC ID."
  type        = string
}

variable "private_dns" {
  description = "The private Route53 Zone name."
  default     = ""
}

variable "environments" {
  type        = list(string)
  description = "The environments: temp, test, prev and prod"
}

variable "main_public_dns" {
  type        = string
  description = "The main public DNS zone name."
}

variable "env_public_dns" {
  type        = string
  description = "The environment specific public DNS zone name."
}

variable "app_public_dns" {
  type        = string
  description = "The public DNS name for the application zone(s)."
}

variable "ds_public_dns" {
  type        = string
  description = "The full public DNS zone name for the DS zone(s)."
}

variable "ds_dns_name" {
  type        = string
  description = "The ds name for the DNS zone."
}

variable "env_public_dns_id" {
  type        = string
  description = "The ID of the public DNS account/environment zone(s)."
}

variable "i_alb_zone_id" {
  type        = string
  description = "The internal ALB DNS Zone ID."
}

variable "i_alb_dns_name" {
  type        = string
  description = "The internal ALB DNS name."
}

variable "tags" {
  type = map(string)
}

variable "shared_services_account_cross_account_assume_role_arn" {
  description = "The IAM role in the Shared Services account to be assumed to allow permissions in it."
}

variable "allow_assume_role_productou_accounts" {
  description = "The assume role policy for the IAM role in the Shared Services AWS account."
}

variable "create_assume_role" {
  type        = string
  description = "Whether to create the assume role"
}

variable "create_dns_certs" {
  type = string
}

variable "ds_cards_records" {
  type    = list(string)
  default = []
}