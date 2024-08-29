resource "aws_kms_key" "workspaces" {
  description             = "Workspaces KMS Key"
  deletion_window_in_days = 7

}

resource "aws_kms_alias" "workspaces" {
  name          = "alias/${var.app}"
  target_key_id = aws_kms_key.workspaces.key_id
}
