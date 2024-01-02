variable "region" {
  type        = string
  description = "AWS region to deploy to. "
  default     = "us-east-1"
}

variable "kms_arn" {
  type        = string
  description = "encryption kms arn aws_kms_key.mykey.arn"

  validation {
    condition     = can(regex("^arn:aws:kms:\\w+(?:-\\w+)+:\\d{12}:key\\/[\\w\\d]+", var.kms_arn))
    error_message = "Invalid kms arn"
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