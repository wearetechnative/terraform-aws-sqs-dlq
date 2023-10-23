resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "${var.name}-monitoring"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = 1
  alarm_description         = "P5"
  insufficient_data_actions = []

  dimensions = {
    QueueName = aws_sqs_queue.this.name
  }
}
