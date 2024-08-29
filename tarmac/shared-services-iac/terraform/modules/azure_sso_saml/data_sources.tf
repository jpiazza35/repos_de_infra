// Get Microsft Graph Components
data "azuread_application_published_app_ids" "graph" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.graph.result.MicrosoftGraph
}

data "azuread_group" "assignment" {
  for_each         = toset(var.groups)
  display_name     = each.value
  security_enabled = true
}

data "azuread_application_template" "app" {
  count        = var.gallery ? 1 : 0
  display_name = var.app
}
