locals {
  az_max = 3 # Limits resource creation to 3 availability zones. To expand beyond this we need to redesign our subnet sizes - so probably not a good idea.

  # Organization supernet
  org_supernet_cidr = "10.0.0.0/8"

  # Secondary CIDR - Must be /16
  secondary_cidr = "100.64.0.0/16"

  # This variable determines which 3 AZs to build the subnets in. AZ names vary from account to account so we refer to them by IDs.
  # Choose up to 3 zones. Because of the immutable properties of certain infrastructure, changing these values will likely require destroying all dependent projects.
  aws_enabled_azs = data.aws_region.current.name == "us-east-1" ? [
    "use1-az1",
    "use1-az5",
    "use1-az6"
    ] : [
    "use2-az1",
    "use2-az2",
    "use2-az3",
  ]

  # Roles defined in the Security_Prod account for Taegis log collection.
  taegis_vpc_monitor_role = "arn:aws:iam::481468670815:role/sc-shared-scwx-vpcflow-monitor-01-LambdaIamRole-Z1BLO3ECHYR9"

  taegis_elb_monitor_role = "arn:aws:iam::481468670815:role/sc-shared-scwx-alb-monitor-01-LambdaIamRole-1A2QMGCEIIY69"

  private_route_tables = [
    for rt in aws_route_table.private : rt.id
  ]

}
