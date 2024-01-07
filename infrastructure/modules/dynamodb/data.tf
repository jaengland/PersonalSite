locals {
  dynamo_append = "-${var.branch_name}"
  dynamodb_name = "${var.dynamo_name}${local.dynamo_append}"
}