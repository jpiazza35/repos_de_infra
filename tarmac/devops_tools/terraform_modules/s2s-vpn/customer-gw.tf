resource "aws_customer_gateway" "example-account_customer_gateway" {
  ip_address  = var.public_ip
  type        = "ipsec.1"
  bgp_asn     = 65000
  device_name = "DataTrans on-prem gateway"

  tags = merge(
    {
      Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-cw"
    },
    var.tags,
  )
}