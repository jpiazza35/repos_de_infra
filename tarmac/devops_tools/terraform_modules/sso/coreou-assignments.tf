### Admin CoreOU AWS account assignments ###

# This sets the AdminPermissionSet to the LoggingAdminGroup and links it to the Logging & Monitoring AWS Account
resource "aws_ssoadmin_account_assignment" "admin_logging" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn

  principal_id   = data.aws_identitystore_group.admin_logging.group_id
  principal_type = "GROUP"

  target_id   = var.logging_aws_account_id
  target_type = "AWS_ACCOUNT"
}


# This sets the AdminPermissionSet to the SecurityAdminGroup and links it to the Security AWS Account
resource "aws_ssoadmin_account_assignment" "admin_security" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn

  principal_id   = data.aws_identitystore_group.admin_security.group_id
  principal_type = "GROUP"

  target_id   = var.security_aws_account_id
  target_type = "AWS_ACCOUNT"
}

### Read-Only CoreOU AWS account assignments ###

# This sets the ReadOnlyPermissionSet to the LoggingReadOnlyGroup and links it to the Logging & Monitoring AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_logging" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_logging.group_id
  principal_type = "GROUP"

  target_id   = var.logging_aws_account_id
  target_type = "AWS_ACCOUNT"
}


# This sets the ReadOnlyPermissionSet to the SecurityReadOnlyGroup and links it to the Security AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_security" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_security.group_id
  principal_type = "GROUP"

  target_id   = var.security_aws_account_id
  target_type = "AWS_ACCOUNT"
}

