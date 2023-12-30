
module "site_s3_bucket" {
  source = "./modules/s3"

  bucket_name = ""
  branch_name = ""
  kms_arn = ""
  bucket_versioning = "Disabled"
}