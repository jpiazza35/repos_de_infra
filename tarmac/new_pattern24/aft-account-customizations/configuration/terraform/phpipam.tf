resource "phpipam_first_free_subnet" "new_subnet" {
  parent_subnet_id = data.aws_region.current.name == "us-east-1" ? data.phpipam_subnet.supernet[0].id : data.phpipam_subnet.ohio[0].id
  count            = local.create_vpc ? 1 : 0
  section_id       = data.phpipam_section.sc.id
  subnet_mask      = 23
  description      = local.account_name
  is_full          = true
  show_name        = true
}
