variable "bucket_regional_domain_name" {
  type        = string
  description = "Domain of the source bucket"
  #TODO: Validation
}

variable "domain" {
  type        = string
  description = "Domain name to point at cloudfront"
  #TODO: Validation
}

variable "branch_name" {
  type        = string
  description = "Name of the bucket"

  validation {
    condition     = length(var.branch_name) < 55
    error_message = "The branch_name should be less than 8 characters"
  }
}