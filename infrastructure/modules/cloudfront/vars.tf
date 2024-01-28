variable "bucket_regional_domain_name" {
  type        = string
  description = "Domain of the source bucket"

  validation {
    condition     = can(regex("^http.+\\.s3-website-(us|eu)-(east|west|central)-(1|2)\\.amazonaws\\.com$", var.bucket_regional_domain_name))
    error_message = "Invalid domain"
  }
}

variable "domain" {
  type        = string
  description = "Domain name to point at cloudfront"
  
  validation {
    condition     = can(regex("^((?!-)[A-Za-z0-9-]{1, 63}(?<!-)\\.)+[A-Za-z]{2, 6}$" , var.domain))
    error_message = "Invalid domain"
  }
}

variable "branch_name" {
  type        = string
  description = "Name of the bucket"

  validation {
    condition     = length(var.branch_name) < 55
    error_message = "The branch_name should be less than 8 characters"
  }
}