locals {
  # Roles defined in the Security_Prod account for Taegis log collection.
  taegis_vpc_monitor_role = "arn:aws:iam::481468670815:role/sc-shared-scwx-vpcflow-monitor-01-LambdaIamRole-Z1BLO3ECHYR9"

  taegis_elb_monitor_role = "arn:aws:iam::481468670815:role/sc-shared-scwx-alb-monitor-01-LambdaIamRole-1A2QMGCEIIY69"

  private_route_tables = [
    for rt in aws_route_table.private : rt.id
  ]

  subnet_azs = data.aws_region.current.name == "us-east-1" ? [
    "use1-az1",
    "use1-az5",
    "use1-az6"
    ] : [
    "use2-az1",
    "use2-az2",
    "use2-az3",
  ]
}
