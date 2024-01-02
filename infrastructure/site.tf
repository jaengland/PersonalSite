
module "site_s3_bucket" {
  source = "./modules/s3"

  bucket_name       = "jaengland-personal-site"
  branch_name       = var.branch_name
  kms_arn           = var.kms_arn
  bucket_versioning = "Disabled"
}

module "site_s3_bucket" {
  source = "./modules/cloudfront"

  branch_name                 = var.branch_name
  bucket_regional_domain_name = module.site_s3_bucket.cloudfront_distribution_domain_name

}