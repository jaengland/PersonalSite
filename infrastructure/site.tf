
module "site_s3_bucket" {
  source = "./modules/s3"

  bucket_name                     = "jaengland-personal-site"
  branch_name                     = var.branch_name
  kms_arn                         = var.kms_arn
  bucket_versioning               = "Disabled"
  aws_cloudfront_distribution_arn = module.frontend_cloudfront.cloudfront_distribution_arn
}

module "frontend_cloudfront" {
  source = "./modules/cloudfront"

  branch_name                 = var.branch_name
  bucket_regional_domain_name = module.site_s3_bucket.bucket_regional_domain_name
  domain                      = var.domain
}

module "dynamodb" {
  source = "./modules/dynamodb"

  dynamo_name = "SiteInfo"
  branch_name = var.branch_name
  kms_arn     = var.kms_arn
}

module "lambda_gen_pages" {
  source = "./modules/lambda_gen_pages"
  
  function_name  = "jaengland_gen_pages"
  lambda_handler = "lambda_function.lambda_handler"
  dynamo_arn     = module.dynamodb.dynamo_arn
  s3_bucket_arn  = module.site_s3_bucket.bucket_arn
  lambda_variables = {
    dynamo_table = "${module.dynamodb.dynamo_table_name}"
    s3_bucket    = "${module.site_s3_bucket.bucket_name}"

  }

}

resource "aws_s3_object" "site" {
  for_each = fileset("../site_template/", "**")

  bucket      = module.site_s3_bucket.bucket_name
  key         = each.value
  source      = "../site_template/${each.value}"
  source_hash = filemd5("../site_template/${each.value}")
}