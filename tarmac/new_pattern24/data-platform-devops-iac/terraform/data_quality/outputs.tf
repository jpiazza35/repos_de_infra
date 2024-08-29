output "s3_endpoint_ips" {
  value = flatten([
    for network_interface_id, network_interface in data.aws_network_interface.s3 :
    network_interface.private_ips
  ])
}