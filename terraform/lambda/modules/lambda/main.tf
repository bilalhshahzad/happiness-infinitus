locals {
  lambda = {
    "s3" = {
      "name" = "${var.random_pet_id}-lambda-s3"
      "namespace" = "/s3/service/lambda/"
      "a_bucekt_id" = var.a_bucket_id
      "b_bucekt_id" = var.b_bucket_id
      "policy"      = data.aws_iam_policy_document.s3.json
    },
    "cloudwatch" = {
      "name" = "${var.random_pet_id}-lambda-cloudwatch"
      "namespace" = "/cloudwatch/service/lambda/"
      "policy"      = data.aws_iam_policy_document.cloudwatch.json
    }
  }
}

data "archive_file" "this" {
  source_file  = "${path.module}/deploy/main.py"
  output_path = "${path.module}/deploy/lambda_function.zip"
  type        = "zip"
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]

    resources = [
      "arn:aws:s3:::${var.a_bucket_id}",
      "arn:aws:s3:::${var.a_bucket_id}/*"
    ]
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::${var.b_bucket_id}",
      "arn:aws:s3:::${var.b_bucket_id}/*"
    ]
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "this" {
    name = "${var.random_pet_id}-lambda-role"
    path = "/role/s3/service/lambda/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "this" {
  for_each = local.lambda
  name_prefix     = "${each.value.name}-policy"
  path     = "/policy${each.value.namespace}"
  policy   = each.value.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = local.lambda
  role = aws_iam_role.this.id
  policy_arn = aws_iam_policy.this[each.key].arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.id}"
  retention_in_days = 7
}

resource "aws_lambda_permission" "this" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.this.arn
    principal = "s3.amazonaws.com"
    source_arn = var.a_bucket_arn
}

resource "aws_lambda_function" "this" {
    filename = "${path.module}/deploy/lambda_function.zip"
    source_code_hash = data.archive_file.this.output_base64sha256
    function_name = "${var.random_pet_id}-s3-lambda"
    role = aws_iam_role.this.arn
    handler = "main.lambda_handler"
    runtime = "python3.8"
    timeout          = 15
    layers           = [aws_lambda_layer_version.this.arn]

    environment {
        variables = {
            DST_BUCKET = var.b_bucket_id,
            REGION = var.aws_region
        }
    }
}

resource "aws_lambda_layer_version" "this" {
  filename            = "${path.module}/deploy/layer/pillow.zip"
  layer_name          = "${var.random_pet_id}-layer-local"
  source_code_hash    = filebase64sha256("${path.module}/deploy/layer/pillow.zip")
}

resource "aws_s3_bucket_notification" "this" {
    bucket = var.a_bucket_id
    lambda_function {
        lambda_function_arn = aws_lambda_function.this.arn
        events = ["s3:ObjectCreated:*"]
    }

    depends_on = [ aws_lambda_permission.this ]
}