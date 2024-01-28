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
  aliases             = [var.domain]
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
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  price_class = "PriceClass_100"
}

#
# ACM/Route53 resources
#

data "aws_route53_zone" "domain" {
  name = var.domain
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  count   = 1
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.validation.*.fqdn
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.static_site_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


# not free: Add aws_waf
# not free: Add aws_shield_protection

