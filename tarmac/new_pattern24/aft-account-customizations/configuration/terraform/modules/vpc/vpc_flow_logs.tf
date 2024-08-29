resource "aws_s3_bucket_policy" "flowlogs" {
  provider = aws.logs
  bucket   = data.aws_arn.flowlogs.resource
  policy   = data.aws_iam_policy_document.flow_logging.json
}

resource "aws_s3_bucket_policy" "elblogs" {
  provider = aws.logs
  bucket   = data.aws_arn.elblogs.resource
  policy   = data.aws_iam_policy_document.elb_logging.json
}

# Enable logging to log archive account
resource "aws_flow_log" "taegis" {
  log_destination          = data.aws_ssm_parameter.flowlogs.value
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.vpc.id
  max_aggregation_interval = 60
  log_format               = "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}"
  destination_options {
    per_hour_partition = true
  }
  tags = merge(
    var.tags,
    {
      "cn:service"     = "security"
      "Name"           = "LogArchive"
      "SourceCodeRepo" = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
  depends_on = [
    aws_s3_bucket_policy.flowlogs
  ]
}

# Enable logging to the local S3 bucket
resource "aws_flow_log" "local" {
  log_destination          = var.flowlog_bucket_arn
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.vpc.id
  max_aggregation_interval = 60
  log_format               = "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}"
  destination_options {
    per_hour_partition = true
  }
  tags = merge(
    var.tags,
    {
      "cn:service"     = "security"
      "Name"           = "Local"
      "SourceCodeRepo" = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}
