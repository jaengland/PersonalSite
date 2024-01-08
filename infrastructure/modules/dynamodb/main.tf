resource "aws_dynamodb_table" "siteinfo" {
  name           = local.dynamodb_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "page_type"
  range_key      = "item_name"

  attribute {
    name = "page_type"
    type = "S"
  }

  attribute {
    name = "item_name"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_arn
  }
}
