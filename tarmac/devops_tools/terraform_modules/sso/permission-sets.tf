# The Admin permission set.
resource "aws_ssoadmin_permission_set" "example-account_admin" {
  name             = "AdminPermissionSet"
  description      = "example-account Admin Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.example-account.arns)[0]
  session_duration = "PT8H"

  tags = var.tags
}

# The Read-Only permission set.
resource "aws_ssoadmin_permission_set" "example-account_read_only" {
  name             = "ReadOnlyPermissionSet"
  description      = "example-account Read-Only Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.example-account.arns)[0]
  session_duration = "PT8H"

  tags = var.tags
}

# The Billing permission set.
resource "aws_ssoadmin_permission_set" "example-account_billing" {
  name             = "BillingPermissionSet"
  description      = "example-account Billing Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.example-account.arns)[0]
  session_duration = "PT2H"

  tags = var.tags
}