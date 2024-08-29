# Service_Linked Role for IPAM 
resource "aws_iam_service_linked_role" "ipam" {
  aws_service_name = "ipam.amazonaws.com"
  description      = "Allows VPC IP Address Manager to access VPC resources and integrate with AWS Organizations on your behalf."
}