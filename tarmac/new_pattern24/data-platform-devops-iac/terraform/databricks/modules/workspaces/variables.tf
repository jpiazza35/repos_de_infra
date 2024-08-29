variable "databricks_account_id" {}
variable "databricks_username" {}
variable "databricks_password" {}
variable "env" {}
variable "app" {}
variable "tags" {}

variable "region" {}

variable "account_id" {}
variable "vpc_id" {}
variable "security_group_ids" {}
variable "private_subnet_ids" {}
variable "local_subnet_ids" {}
variable "vpc_cidr" {}
variable "ss_network_vpc_ids" {}
variable "groups" {}
variable "azure_app_roles" {}
variable "dns_name" {}

variable "technical_groups" {
  description = "AD groups that should receive elevated entitlements."
}

variable "fivetran_vpce_id" {
  description = "VPC Endpoint ID for Fivetran"
}