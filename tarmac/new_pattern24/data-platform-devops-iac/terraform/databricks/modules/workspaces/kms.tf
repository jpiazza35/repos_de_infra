resource "aws_kms_key" "customer_managed_key" {

  policy = data.aws_iam_policy_document.databricks_managed_services_and_storage_cmk.json
}

resource "aws_kms_alias" "customer_managed_key_alias" {

  name          = "alias/${local.prefix}-customer-managed-key-alias"
  target_key_id = aws_kms_key.customer_managed_key.key_id
}

