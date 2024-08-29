resource "phpipam_first_free_subnet" "new_subnet" {
  count            = terraform.workspace == "tgw" ? 0 : 1
  parent_subnet_id = data.phpipam_subnet.ohio[0].id
  section_id       = data.phpipam_section.sc.id
  subnet_mask      = 23
  description      = local.account_name
  is_full          = true
  show_name        = true
}
