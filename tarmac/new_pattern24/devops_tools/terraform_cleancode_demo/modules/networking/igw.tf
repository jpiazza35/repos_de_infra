resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.args.env}-${var.args.project}-${var.args.product}-${var.args.name}-igw"
  }
}