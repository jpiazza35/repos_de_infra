# The AWS SSO groups that will allow access to the AWS accounts
resource "aws_identitystore_group" "group" {
  for_each          = toset(local.groups)
  display_name      = each.value
  description       = "This group allows access to the assigned AWS account."
  identity_store_id = tolist(data.aws_ssoadmin_instances.tarmac.identity_store_ids)[0]
}
