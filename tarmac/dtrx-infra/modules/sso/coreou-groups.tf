########### Admin CoreOU AWS account groups ###########

# The AWS SSO group that will allow Admin access to the Logging & Monitoring AWS account
data "aws_identitystore_group" "admin_logging" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "LoggingAdminGroup"
  }
}

# The AWS SSO group that will allow Admin access to the Security AWS account
data "aws_identitystore_group" "admin_security" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "SecurityAdminGroup"
  }
}

########### Read-Only CoreOU AWS account groups ###########

# The AWS SSO group that will allow Read Only access to the Logging & Monitoring AWS account
data "aws_identitystore_group" "read_only_logging" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "LoggingReadOnlyGroup"
  }
}

# The AWS SSO group that will allow Read Only access to the Security AWS account
data "aws_identitystore_group" "read_only_security" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "SecurityReadOnlyGroup"
  }
}