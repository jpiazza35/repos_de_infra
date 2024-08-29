########### Admin dtcloud-proxy AWS account groups ###########

# The AWS SSO group that will allow Admin access to the dtcloud-proxy-dev AWS account
data "aws_identitystore_group" "admin_proxy_dev" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyDevAdminGroup"
  }
}

# The AWS SSO group that will allow Admin access to the dtcloud-proxy-test AWS account
data "aws_identitystore_group" "admin_proxy_test" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyTestAdminGroup"
  }
}

# The AWS SSO group that will allow Admin access to the dtcloud-proxy-prod AWS account
data "aws_identitystore_group" "admin_proxy_prod" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyProdAdminGroup"
  }
}

########### Read-Only dtcloud-proxy AWS account groups ###########

# The AWS SSO group that will allow Read Only access to the dtcloud-proxy-dev AWS account
data "aws_identitystore_group" "read_only_proxy_dev" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyDevReadOnlyGroup"
  }
}

# The AWS SSO group that will allow Read Only access to the dtcloud-proxy-test AWS account
data "aws_identitystore_group" "read_only_proxy_test" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyTestReadOnlyGroup"
  }
}

# The AWS SSO group that will allow Read Only access to the dtcloud-proxy-prod AWS account
data "aws_identitystore_group" "read_only_proxy_prod" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.dtcloud.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "ProxyProdReadOnlyGroup"
  }
}
