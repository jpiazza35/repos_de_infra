locals {
  os_routes = setproduct(aws_route_table.example-account_private.*.id, var.open_search_cidr)
}