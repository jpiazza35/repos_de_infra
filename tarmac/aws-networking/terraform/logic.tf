# Workspace validator
resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = (terraform.workspace == "tgw" && data.aws_region.current.name == "us-east-1") || (terraform.workspace == "tgw-ohio" && data.aws_region.current.name == "us-east-2")
      error_message = "SANITY CHECK: This is a sensitive project. Your current workspace is '${terraform.workspace}'. You must be in the 'tgw' or 'tgw-ohio' workspace and export the appropriate aws region to apply this terraform."
    }
  }
}
