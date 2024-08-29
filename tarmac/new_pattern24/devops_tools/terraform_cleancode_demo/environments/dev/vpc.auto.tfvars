vpc_args = {
  main = {
    cidr_block    = "10.10.0.0/16"
    subnet_groups = ["public", "private", "db"]
  }
}