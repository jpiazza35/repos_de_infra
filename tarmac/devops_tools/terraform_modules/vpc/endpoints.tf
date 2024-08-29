resource "aws_vpc_endpoint" "private_s3" {
  count              = var.create_vpc_s3_endpoint ? 1 : 0
  vpc_id             = aws_vpc.example-account_vpc.id
  service_name       = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.example-account_vpc.id]
  subnet_ids         = aws_subnet.example-account_private.*.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-interface-vpc-endpoint"
    },
  )
}

resource "aws_vpc_endpoint" "private_secrets" {
  count              = var.create_vpc_secrets_endpoint ? 1 : 0
  vpc_id             = aws_vpc.example-account_vpc.id
  service_name       = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.example-account_vpc.id]
  subnet_ids         = aws_subnet.example-account_private.*.id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-secretsmanager-vpc-endpoint"
    },
  )
}

resource "aws_vpc_endpoint" "private_sqs" {
  count              = var.create_sqs_vpc_endpoint ? 1 : 0
  vpc_id             = aws_vpc.example-account_vpc.id
  service_name       = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.example-account_vpc.id]
  subnet_ids         = aws_subnet.example-account_private.*.id


  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-sqs-vpc-endpoint"
    },
  )
}