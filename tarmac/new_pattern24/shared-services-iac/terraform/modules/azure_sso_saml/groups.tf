# Assigns the groups to the Enterprise Application, if any.
resource "azuread_app_role_assignment" "group_assignment" {
  for_each            = data.azuread_group.assignment
  app_role_id         = random_uuid.app_roles[0].result
  principal_object_id = each.value.id
  resource_object_id  = azuread_service_principal.user.object_id

}
