output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.static_site_distribution.domain_name
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.static_site_distribution.arn
}