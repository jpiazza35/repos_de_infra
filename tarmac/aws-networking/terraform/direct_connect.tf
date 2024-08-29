module "dx" {
  source = "./modules/direct_connect"
  providers = {
    aws      = aws,
    aws.use2 = aws.use2
  }

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  name        = "cn-qts-chicago"
  tgw_id      = module.tgw.tgw.id
  dx_id       = var.dx_id
  aws_asn     = var.dx_aws_asn
  cx_asn      = var.dx_cx_asn
  vlan        = var.dx_vlan
  aws_address = var.dx_aws_address
  cx_address  = var.dx_cx_address
  prefixes    = var.dx_prefixes["us-east-1"]
  auth_key    = var.dx_auth_key

  tags = merge(
    var.tags,
    {
      Environment    = "shared_services"
      App            = "tgw"
      Resource       = "Managed by Terraform"
      Description    = "Direct Connect Configuration"
      Team           = "DevOps"
      "cn:service"   = "infrastructure"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

resource "aws_dx_gateway_association" "dxgw_association" {
  count = terraform.workspace == "tgw-ohio" ? 1 : 0

  dx_gateway_id         = data.aws_dx_gateway.dxgw.id
  associated_gateway_id = module.tgw.tgw["id"]
  allowed_prefixes      = var.dx_prefixes["us-east-2"]
}
