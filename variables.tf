variable "name" {
  description = "Unique name dead letter queue."
  type        = string
}

variable "fifo_queue" {
  description = "Only FiFo queues can use FiFo queues as DLQ. Set this to true if you require this."
  type        = bool
}
