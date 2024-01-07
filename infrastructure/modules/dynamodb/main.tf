resource "aws_dynamodb_table" "siteinfo" {
  name           = local.dynamodb_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "type"
  range_key      = "name"

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_arn
  }
}
