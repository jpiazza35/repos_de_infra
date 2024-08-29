# these AZs are always going to have enough IPs for cluster creation, but az names aren't consistent across accounts
# so we can use the output to get the az names for the account we're in
data "aws_availability_zones" "azs" {
  state = "available"
  filter {
    name   = "zone-id"
    values = ["use1-az1", "use1-az5", "use1-az6"]
  }
}
