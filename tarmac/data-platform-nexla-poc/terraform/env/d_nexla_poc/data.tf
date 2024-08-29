data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*az1-public"]
  }
}
