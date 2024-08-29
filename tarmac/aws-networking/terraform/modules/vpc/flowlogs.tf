############################# NOTES ##################################
## Flow log enablement depends on proper S3 bucket policies in the  ##
## AWS LogArchive account. These policies are continually refreshed ##
## during the AFT Account Creation pipeline, which grants proper    ##
## access to all organizational AWS accounts and addresses the      ##
## dependency described here.                                       ##
######################################################################

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
      "cn:service" = "security"
      "Name"       = "LogArchive"
    }
  )
}

# Enable logging to the local S3 bucket
resource "aws_flow_log" "local" {
  log_destination          = terraform.workspace == "tgw" && var.name == "primary-vpc" ? aws_s3_bucket.flowlogs[0].arn : data.aws_s3_bucket.flowlogs.arn
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
      "cn:service" = "security"
      "Name"       = "Local"
    }
  )
}
