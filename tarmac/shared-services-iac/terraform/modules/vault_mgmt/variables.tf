variable "paths" {}
variable "env" {}
variable "cluster_name" {}
variable "k8s_serviceaccount" {}
variable "k8s_cert_issuer_serviceaccount" {
  default = "vault-cert-issuer"
}
variable "create_aws_auth" {
  default = false
}
variable "iam_instance_profile_arn" {
  default = ""
}
