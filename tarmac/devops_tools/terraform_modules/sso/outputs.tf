output "sso_instance" {
  value = sort(data.aws_ssoadmin_instances.example-account.arns)[0]
}