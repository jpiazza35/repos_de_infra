resource "aws_vpn_connection" "example-account_s2s_vpn" {
  transit_gateway_id       = var.transit_gateway_id
  customer_gateway_id      = aws_customer_gateway.example-account_customer_gateway.id
  type                     = "ipsec.1"
  static_routes_only       = false
  local_ipv4_network_cidr  = var.vpn_local_cidr
  remote_ipv4_network_cidr = var.vpn_remote_cidr
  ##Tunnel 1
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = [19, 20, 21, 24]
  tunnel1_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = []
  tunnel1_phase1_lifetime_seconds      = 28800
  tunnel1_phase2_dh_group_numbers      = [19]
  tunnel1_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = []
  tunnel1_phase2_lifetime_seconds      = 3600
  ##Tunnel 2
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = [19, 20, 21, 24]
  tunnel2_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = []
  tunnel2_phase1_lifetime_seconds      = 28800
  tunnel2_phase2_dh_group_numbers      = [19]
  tunnel2_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = []
  tunnel2_phase2_lifetime_seconds      = 3600

  tags = merge(
    {
      Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-s2s-vpn"
    },
    var.tags,
  )
}