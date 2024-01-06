
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

resource "aws_s3_bucket_object" "site" {
  for_each = fileset("../site_template/", "**")

  bucket = module.site_s3_bucket.bucket_name
  key    = each.value
  source = "../site_template/${each.value}"
  etag   = filemd5("../site_template/${each.value}")
}