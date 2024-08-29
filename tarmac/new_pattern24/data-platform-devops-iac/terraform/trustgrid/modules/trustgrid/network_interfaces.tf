resource "aws_network_interface" "public_ni" {
  for_each        = toset(data.aws_subnets.public.ids)
  subnet_id       = each.value
  security_groups = [aws_security_group.ec2.id]
}

# resource "aws_network_interface" "private_ni" {
#   for_each        = toset(data.aws_subnets.private.ids)
#   subnet_id       = each.value
#   security_groups = [aws_security_group.ec2.id]
# }
