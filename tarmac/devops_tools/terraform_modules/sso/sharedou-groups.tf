########### Admin SharedOU AWS account groups ###########

# The AWS SSO group that will allow Admin access to the Shared Services AWS account
data "aws_identitystore_group" "admin_shared" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "SharedAdminGroup"
  }
}

# The AWS SSO group that will allow Admin access to the Networking AWS account
data "aws_identitystore_group" "admin_networking" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "NetworkingAdminGroup"
  }
}

# The AWS SSO group that will allow Admin access to the Infra Code AWS account
data "aws_identitystore_group" "admin_infra_code" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "InfraCodeAdminGroup"
  }
}

########### Read-Only SharedOU AWS account groups ###########

# The AWS SSO group that will allow Read Only access to the Shared Services AWS account
data "aws_identitystore_group" "read_only_shared" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "SharedReadOnlyGroup"
  }
}

# The AWS SSO group that will allow Read Only access to the Networking AWS account
data "aws_identitystore_group" "read_only_networking" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "NetworkingReadOnlyGroup"
  }
}

# The AWS SSO group that will allow Read Only access to the Infra Code AWS account
data "aws_identitystore_group" "read_only_infra_code" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "InfraCodeReadOnlyGroup"
  }
}