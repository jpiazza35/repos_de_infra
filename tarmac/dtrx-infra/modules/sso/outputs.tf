output "sso_instance" {
  value = sort(data.aws_ssoadmin_instances.dtcloud.arns)[0]
}