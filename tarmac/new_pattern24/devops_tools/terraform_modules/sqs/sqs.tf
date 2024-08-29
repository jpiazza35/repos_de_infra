resource "aws_sqs_queue" "sqs" {
  count             = var.create_sqs ? 1 : 0
  name              = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-alerts-queue"
  kms_master_key_id = var.sqs_kms_key_alias

  tags = var.tags
}

resource "aws_sqs_queue_policy" "sqs" {
  count     = var.create_sqs ? 1 : 0
  queue_url = aws_sqs_queue.sqs[count.index].id
  policy    = data.template_file.sqs.rendered
}