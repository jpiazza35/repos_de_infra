# Workspace validator
resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = terraform.workspace == "default"
      error_message = "SANITY CHECK: Your current workspace is '${terraform.workspace}'. You must be in a named workspace other than default to apply this terraform."
    }
  }
}
