resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id

  policy = data.aws_iam_policy_document.resource-policy.json
}

data "aws_iam_policy_document" "resource-policy" {
  source_policy_documents = [for key, value in data.aws_iam_policy_document.resource-policy-perservice : value.json]
}

# add any new services for all resources to for_each
# allow all external services, lockding down per user makes things overly complex
data "aws_iam_policy_document" "resource-policy-perservice" {
  for_each = { "events.amazonaws.com" : { "service" : "events", "resource-prefix" : "rule/" }
    "sns.amazonaws.com" : { "service" : "sns", "resource-prefix" : "" }
  "lambda.amazonaws.com" : { "service" : "lambda", "resource-prefix" : "function:" } }

  statement {
    sid       = each.key
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.this.arn]
    principals {
      type        = "Service"
      identifiers = [each.key]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [join(":", ["arn", data.aws_partition.current.id
        , each.value.service, data.aws_region.current.name
      , data.aws_caller_identity.current.account_id, "${each.value.resource-prefix}*"])]
    }
  }
}
