# Terraform AWS [sqs-dlq] ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-module-name/tflint.yaml?style=plastic)

This module implements a SQS configured as deadletter queue.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

This SQS implements no KMS CMK and a very lenient policy in order to catch any messages that are not processed properly. This SQS module is different in that its policy allows all types of certain resources to make it easily usable. Least privilege is difficult because many services with DLQ support rely on service principals. So we just add them all by default.

You generally have one DLQ per account and region to catch any infrastructure issues from other infrastructure components.

It's not recommended to use this DLQ as a DLQ from the application point of view as it could expose sensitive data.

We have a CloudWatch alarm that allows you to warn any incident system automatically with [terraform-aws-observability-sender](https://github.com/TechNative-B-V/terraform-aws-observability-sender). The observability-sender listens for any CloudWatch alarms going into alarm that are not performance metrics.

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage

The primary usecase is demonstrated below:

```ruby
module "sqs_dlq" {
  source = "git@github.com:TechNative-B-V/modules-aws.git//sqs_dlq?ref=f67aaeb1801526b760d04d4bb461778c9544e054"

  name = "sqs_dlq"
  fifo_queue = false
}
```

If the SQS is a deadletter queue from another fifo queue then use a fifo deadletter queue (`fifi_queue` = true).

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.resource-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.resource-policy-perservice](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Only FiFo queues can use FiFo queues as DLQ. Set this to true if you require this. | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Unique name dead letter queue. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_dlq_arn"></a> [sqs\_dlq\_arn](#output\_sqs\_dlq\_arn) | n/a |
<!-- END_TF_DOCS -->
