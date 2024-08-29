# The Admin permission set.
resource "aws_ssoadmin_permission_set" "dtcloud_admin" {
  name             = "AdminPermissionSet"
  description      = "Dtcloud Admin Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.dtcloud.arns)[0]
  session_duration = "PT8H"

  tags = var.tags
}

# The Read-Only permission set.
resource "aws_ssoadmin_permission_set" "dtcloud_read_only" {
  name             = "ReadOnlyPermissionSet"
  description      = "Dtcloud Read-Only Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.dtcloud.arns)[0]
  session_duration = "PT8H"

  tags = var.tags
}

# The Billing permission set.
resource "aws_ssoadmin_permission_set" "dtcloud_billing" {
  name             = "BillingPermissionSet"
  description      = "Dtcloud Billing Permission Set."
  instance_arn     = tolist(data.aws_ssoadmin_instances.dtcloud.arns)[0]
  session_duration = "PT2H"

  tags = var.tags
}