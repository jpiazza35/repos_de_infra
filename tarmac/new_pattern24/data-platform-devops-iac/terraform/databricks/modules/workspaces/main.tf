# Workspace validator
resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = (terraform.workspace == "sdlc" || terraform.workspace == "dev" || terraform.workspace == "prod" || terraform.workspace == "preview")
      error_message = "SANITY CHECK: Your current workspace is '${terraform.workspace}'. You must be in the 'sdlc','dev', 'preview', or 'prod' workspace to apply this terraform."
    }
  }
}
