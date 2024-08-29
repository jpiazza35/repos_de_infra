# Create the organization Global Network
module "gn" {
  source = "./modules/global_network"

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  name = "sch-global-network"

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "Global Network Configuration"
      Team         = "DevOps"
      "cn:service" = "infrastructure"
    }
  )
}

resource "aws_networkmanager_transit_gateway_registration" "tgw" {
  global_network_id   = terraform.workspace == "tgw" ? module.gn["us-east-1"].network.id : data.aws_networkmanager_global_networks.main.ids[0]
  transit_gateway_arn = module.tgw.tgw.arn
}
