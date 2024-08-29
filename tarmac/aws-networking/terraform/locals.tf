locals {
  account_name = "SS_NETWORK"
  # Get the contents from all private zone files, concatenate them together, and decode the json to a variable.
  dns_zones_private = jsondecode(format("[%s]", join(",", [
    for fn in fileset(".", "dns_zones/private/*.json") : file(fn)
  ])))

  # Get the contents from all public zone files, concatenate them together, and decode the json to a variable.
  dns_zones_public = jsondecode(format("[%s]", join(",", [
    for fn in fileset(".", "dns_zones/public/*.json") : file(fn)
  ])))
}
