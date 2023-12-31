variable "bucket_name" {
  type        = string
  description = "Name of the bucket"

  validation {
    condition     = length(var.bucket_name) < 55 && length(var.bucket_name) > 3
    error_message = "The bucket_name should be less than 55 characters to allow for branch variable"
  }
}

variable "branch_name" {
  type        = string
  description = "Name of the bucket"

  validation {
    condition     = length(var.branch_name) < 9
    error_message = "The branch_name should be less than 8 characters"
  }
}

variable "kms_arn" {
  type        = string
  description = "encryption kms arn aws_kms_key.mykey.arn"

  validation {
    condition     = can(regex("^arn:aws:kms:\\w+(?:-\\w+)+:\\d{12}:key\\/[\\w\\d]+", var.kms_arn))
    error_message = "Invalid kms arn"
  }
}


variable "bucket_versioning" {
  type        = string
  description = "Versioning 'Enabled' or 'Disabled'"
  default     = "Disabled"
}

variable "aws_cloudfront_distribution_arn" {
  type        = string
  description = "Cloudfront distribution arn"
}

variable "aws_lambda_role_arn" {
  type        = string
  description = "Lambda role arn"
}