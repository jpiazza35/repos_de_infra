# Create the DX Gateway
resource "aws_dx_gateway" "dxgw" {
  name            = format("%s-dxgw", var.name)
  amazon_side_asn = var.aws_asn
}

# Create the TGW virtual interface
resource "aws_dx_transit_virtual_interface" "vif" {
  provider         = aws.use2
  connection_id    = var.dx_id
  dx_gateway_id    = aws_dx_gateway.dxgw.id
  name             = format("%s-vif", var.name)
  vlan             = var.vlan
  address_family   = "ipv4"
  bgp_asn          = var.cx_asn
  amazon_address   = var.aws_address
  customer_address = var.cx_address
  mtu              = var.mtu
  bgp_auth_key     = var.auth_key

  tags = {
    "com.amazonaws.dx.resiliencecheck" = "disabled"
  }

}

resource "aws_dx_gateway_association" "dxgw_association" {
  dx_gateway_id         = aws_dx_gateway.dxgw.id
  associated_gateway_id = var.tgw_id
  allowed_prefixes      = var.prefixes
}
