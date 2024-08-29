# Workspace validator
resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = (terraform.workspace == "dev" || terraform.workspace == "prod")
      error_message = "SANITY CHECK: Your current workspace is '${terraform.workspace}'. You must be in the 'dev' or 'prod' workspace to apply this terraform."
    }
  }
}
