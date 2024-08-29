
data "phpipam_subnet" "azure" {
  count             = local.default
  section_id        = 5
  description_match = "Azure"
}

data "phpipam_subnet" "aws" {
  count             = local.default
  section_id        = 5
  description_match = "AWS"
}
