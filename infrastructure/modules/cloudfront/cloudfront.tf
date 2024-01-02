resource "aws_cloudfront_origin_access_control" "origin_access_control" {
  name                              = "${var.bucket_regional_domain_name}${local.suffix}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_site_distribution" {
  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access_control.id
    origin_id                = "S3-static-site"
  }

  enabled             = true
  default_root_object = "index.html"
  # TODO: Add alias for custom domain. REQUIRES: Custom domain
  # TODO: Consider enabling logging for troubleshooting. REQUIRES: logging bucket

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-static-site"
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 3600
    default_ttl = 86400
    max_ttl     = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
    # TODO: migrate to custom domain and ACM cert. REQUIRES: Custom domain
  }

  price_class = "PriceClass_100"
}

# TODO: Add aws_acm_certificate  
# TODO: Add aws_route53_record
# TODO: Add aws_acm_certificate_validation
# TODO: Add aws_waf
# TODO: Add aws_shield_protection
