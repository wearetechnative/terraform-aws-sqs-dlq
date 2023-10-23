resource "aws_sqs_queue" "this" {
  name_prefix                = "dlq-${var.name}-"
  visibility_timeout_seconds = 60      # prevent polling the same message over and over in console
  message_retention_seconds  = 1209600 # 14 days
  max_message_size           = 262144  # 256Kb
  delay_seconds              = 0
  redrive_allow_policy = jsonencode({
    redrivePermission = "allowAll"
  })
  fifo_queue = var.fifo_queue

  # encryption disabled
  # - corner cases will only end up in this queue
  # - limits application of DLQ
}
