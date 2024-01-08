data "aws_iam_policy_document" "lambda_role_trust" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name_prefix        = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_trust.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "AllowLogging"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid = "AllowDynamo"
    actions = [
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:GetItem"
    ]
    resources = [var.dynamo_arn]
    effect    = "Allow"
  }
  statement {
    sid = "AllowS3"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [var.s3_bucket_arn]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  handler          = var.lambda_handler
  role             = aws_iam_role.lambda_role.arn
  runtime          = var.runtime
  filename         = var.file.output_path
  source_code_hash = var.file.output_base64sha256
  timeout          = 60

  environment {
    variables = var.lambda_variables
  }

}