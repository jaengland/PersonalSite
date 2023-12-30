locals {
  bucket_append = "-${var.branch_name}"
  bucket_name   = "${var.bucket_name}${local.bucket_append}"
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    condition {
      test     = "bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [data.aws_cloudfront_distribution.dist.arn]
    }
  }
}

data "aws_cloudfront_distribution" "dist" {
  id = aws_cloudfront_distribution.distribution.id
}