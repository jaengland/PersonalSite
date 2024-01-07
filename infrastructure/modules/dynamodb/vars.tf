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

variable "dynamo_name" {
  type        = string
  description = "Name of the dynano"

  validation {
    condition     = length(var.dynamo_name) < 55 && length(var.dynamo_name) > 3
    error_message = "The dynamo_name should be less than 55 characters to allow for branch variable"
  }
}