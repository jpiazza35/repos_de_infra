### Admin ProductOU AWS account assignments ###

# This sets the AdminPermissionSet to the ProxyDevAdminGroup and links it to the example-account-proxy-dev AWS Account
resource "aws_ssoadmin_account_assignment" "admin_proxy_dev" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn

  principal_id   = data.aws_identitystore_group.admin_proxy_dev.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_dev_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the AdminPermissionSet to the ProxyTestAdminGroup and links it to the example-account-proxy-test AWS Account
resource "aws_ssoadmin_account_assignment" "admin_proxy_test" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn

  principal_id   = data.aws_identitystore_group.admin_proxy_test.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_test_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the AdminPermissionSet to the ProxyProdAdminGroup and links it to the example-account-proxy-prod AWS Account
resource "aws_ssoadmin_account_assignment" "admin_proxy_prod" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn

  principal_id   = data.aws_identitystore_group.admin_proxy_prod.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_prod_aws_account_id
  target_type = "AWS_ACCOUNT"
}

### Read-Only ProductOU AWS account assignments ###

# This sets the ReadOnlyPermissionSet to the ProxyDevReadOnlyGroup and links it to the Shared Services AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_proxy_dev" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_proxy_dev.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_dev_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the ReadOnlyPermissionSet to the ProxyTestReadOnlyGroup and links it to the example-account-proxy-test AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_proxy_test" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_proxy_test.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_test_aws_account_id
  target_type = "AWS_ACCOUNT"
}

# This sets the ReadOnlyPermissionSet to the ProxyProdReadOnlyGroup and links it to the example-account-proxy-prod AWS Account
resource "aws_ssoadmin_account_assignment" "read_only_proxy_prod" {
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn

  principal_id   = data.aws_identitystore_group.read_only_proxy_prod.group_id
  principal_type = "GROUP"

  target_id   = var.proxy_prod_aws_account_id
  target_type = "AWS_ACCOUNT"
}
