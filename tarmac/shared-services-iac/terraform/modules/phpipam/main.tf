## Create Main Section 
resource "phpipam_section" "section" {
  count       = local.default
  name        = "SullivanCotter"
  description = "Sullivan Cotter CIDR Range Section"
  strict_mode = true
}

## Create Subnet Folders
resource "phpipam_subnet" "ranges" {
  for_each         = terraform.workspace == "sharedservices" ? toset(var.cidr_ranges) : toset([])
  section_id       = phpipam_section.section[0].section_id
  master_subnet_id = data.phpipam_subnet.aws[0].id
  subnet_address   = each.value
  subnet_mask      = 16
  show_name        = true
  description      = each.key == "10.202.0.0" ? "US-EAST-1" : each.key == "10.203.0.0" ? "US-EAST-2" : format("%s/16", each.key)
}

resource "phpipam_subnet" "azure_ranges" {
  for_each         = terraform.workspace == "sharedservices" ? toset(var.azure_cidr_ranges) : toset([])
  section_id       = phpipam_section.section[0].id
  master_subnet_id = data.phpipam_subnet.azure[0].id
  subnet_address   = each.value
  subnet_mask      = 16
  show_name        = true
  description      = format("%s/16", each.key)
}

## Update with existing VPCs
resource "phpipam_subnet" "vpcs" {
  for_each         = terraform.workspace == "sharedservices" ? var.full_vpcs : {}
  section_id       = phpipam_section.section[0].section_id
  subnet_address   = each.value.vpc_cidr
  subnet_mask      = each.value.mask
  master_subnet_id = phpipam_subnet.ranges["10.202.0.0"].id
  is_full          = true
  show_name        = true
  description      = each.key

}

/* ## Get next available VPC Cidr
resource "phpipam_first_free_subnet" "new_subnet" {
  count = local.default
  parent_subnet_id   = phpipam_subnet.ranges["10.202.0.0"].id
  subnet_mask = 23
  description = "Managed by Terraform"
  is_full = true
  show_name = true
} */
