output "dynamo_table_name" {
  value = aws_dynamodb_table.siteinfo.name
}

output "dynamo_arn" {
  value = aws_dynamodb_table.siteinfo.arn
}