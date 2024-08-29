### Admin SharedOU AWS account assignments ###

# This sets the AdminPermissionSet to the SharedAdminGroup and links it to the Shared Services AWS Account
resource "aws_ssoadmin_account_assignment" "admin_shared" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_admin.arn

  principal_id   = data.aws_identitystore_group.admin_shared.group_id
  principal_type = "GROUP"

  target_id   = var.shared_services_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the AdminPermissionSet to the NetworkingAdminGroup and links it to the Networking AWS Account
resource "aws_ssoadmin_account_assignment" "admin_networking" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_admin.arn

  principal_id   = data.aws_identitystore_group.admin_networking.group_id
  principal_type = "GROUP"

  target_id   = var.networking_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the AdminPermissionSet to the InfraCodeAdminGroup and links it to the Infra Code AWS Account
resource "aws_ssoadmin_account_assignment" "admin_infra_code" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_admin.arn

  principal_id   = data.aws_identitystore_group.admin_infra_code.group_id
  principal_type = "GROUP"

  target_id   = var.infra_code_aws_account_id
  target_type = "AWS_ACCOUNT"
}

### Read-Only SharedOU AWS account assignments ###

# This sets the ReadOnlyPermissionSet to the SharedReadOnlyGroup and links it to the Shared Services AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_shared" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_shared.group_id
  principal_type = "GROUP"

  target_id   = var.shared_services_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the ReadOnlyPermissionSet to the NetworkingReadOnlyGroup and links it to the Networking AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_networking" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_networking.group_id
  principal_type = "GROUP"

  target_id   = var.networking_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the ReadOnlyPermissionSet to the InfraCodeReadOnlyGroup and links it to the Infra Code AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_infra_code" {
  instance_arn       = aws_ssoadmin_permission_set.dtcloud_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dtcloud_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_infra_code.group_id
  principal_type = "GROUP"

  target_id   = var.infra_code_aws_account_id
  target_type = "AWS_ACCOUNT"
}