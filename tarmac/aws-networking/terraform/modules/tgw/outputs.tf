output "tgw" {
  description = "The TGW that was created."
  value       = aws_ec2_transit_gateway.tgw
}

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = try(aws_ram_resource_share.tgw[0].id, "")
}

output "ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = try(aws_ram_principal_association.tgw[0].id, "")
}

output "tgw_default_route_table" {
  description = "The default route table associated with the TGW."
  value       = aws_ec2_transit_gateway.tgw.association_default_route_table_id
}
