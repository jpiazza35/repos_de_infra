# AWS Managed Policies

# The AWS managed Administrator policy attached to the AdminPermissionSet
resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  instance_arn       = aws_ssoadmin_permission_set.example-account_admin.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_admin.arn
}

# The AWS managed Read-Only policy attached to the ReadOnlyPermissionSet
resource "aws_ssoadmin_managed_policy_attachment" "read_only" {
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  instance_arn       = aws_ssoadmin_permission_set.example-account_read_only.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_read_only.arn
}

# The AWS managed job function Billing policy attached to the BillingPermissionSet
resource "aws_ssoadmin_managed_policy_attachment" "billing" {
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
  instance_arn       = aws_ssoadmin_permission_set.example-account_billing.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-account_billing.arn
}