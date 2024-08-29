resource "aws_identitystore_user" "user" {
  for_each          = var.sso_users
  identity_store_id = tolist(data.aws_ssoadmin_instances.tarmac.identity_store_ids)[0]

  display_name = each.value.display_name
  user_name    = each.value.user_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  dynamic "emails" {
    for_each = each.value.emails
    content {
      value   = lookup(emails.value, "value", null)
      primary = lookup(emails.value, "primary", null)
      type    = lookup(emails.value, "type", null)
    }
  }
}