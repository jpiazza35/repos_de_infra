data "aws_caller_identity" "current" {
  provider = aws.requester
}

data "aws_region" "current" {

}
