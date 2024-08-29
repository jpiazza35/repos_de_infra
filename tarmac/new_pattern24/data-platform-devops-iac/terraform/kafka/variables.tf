variable "app" {}
variable "env" {}
variable "name" {}
variable "kafka_version" {}
variable "kafka_instance_type" {}
variable "databricks_account_id" {}
variable "eks_account_id" {}
variable "qa_eks_account_id" {
  default = ""
}