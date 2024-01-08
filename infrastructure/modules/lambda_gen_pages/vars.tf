variable "runtime" {
  type        = string
  description = "Lambda runtime"
  default     = "python3.12"
}

variable "lambda_variables" {
  type        = map(any)
  description = "map of variables"
}

variable "function_name" {
  type        = string
  description = "Name of the Lambda Function"
}

variable "lambda_handler" {
  type        = string
  description = "Lambda handler"
}

variable "dynamo_arn" {
  type        = string
  description = "Arn of dynamot o query"
}

variable "s3_bucket_arn" {
  type        = string
  description = "bucket arn to grant access to"
}

variable "kms_arn" {
  type        = string
  description = "encryption kms arn aws_kms_key.mykey.arn"

  validation {
    condition     = can(regex("^arn:aws:kms:\\w+(?:-\\w+)+:\\d{12}:key\\/[\\w\\d]+", var.kms_arn))
    error_message = "Invalid kms arn"
  }
}