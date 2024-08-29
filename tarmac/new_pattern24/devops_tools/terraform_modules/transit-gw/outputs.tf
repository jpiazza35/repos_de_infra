output "transit_gateway_id" {
  description = "Id of the Transit Gateway in Networking account"
  value       = element(concat(aws_ec2_transit_gateway.example-account_networking_tgw.*.id, tolist([""])), 0)
}