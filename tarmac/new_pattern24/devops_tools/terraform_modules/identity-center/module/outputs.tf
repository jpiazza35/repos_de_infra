output "sso_instance" {
  value = sort(data.aws_ssoadmin_instances.tarmac.arns)[0]
}