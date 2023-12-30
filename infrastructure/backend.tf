terraform {
  backend "s3" {
    encrypt = true
    region = "us-east-1"
    workspace_key_prefix = "personal-site"
  }
}