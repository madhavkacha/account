
# The AWS region currently being used.
data "aws_region" "current" {}

# The AWS account id
data "aws_caller_identity" "current" {}

# The AWS partition (commercial or govcloud)
data "aws_partition" "current" {}

#
# CloudTrail - CloudWatch
#
# This section is used for allowing CloudTrail to send logs to CloudWatch.
#

# This policy allows the CloudTrail service for any account to assume this role.
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# This role is used by CloudTrail to send logs to CloudWatch.
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}

# This CloudWatch Group is used for storing CloudTrail logs.
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = var.cloudwatch_log_group_name
  tags = var.cloudtail_tags
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}:*"]
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  name   = var.iam_policy_name
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}

resource "aws_iam_policy_attachment" "main" {
  name       = "${var.iam_policy_name}-attachment"
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs.arn
  roles      = [aws_iam_role.cloudtrail_cloudwatch_role.name]
}


#
# CloudTrail
#

resource "aws_cloudtrail" "main" {
  name = var.trail_name

  # Send logs to CloudWatch Logs
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_role.arn

  # Send logs to S3
  s3_key_prefix  = var.s3_key_prefix
  s3_bucket_name = aws_s3_bucket.aws_logs.bucket




  # use a single s3 bucket for all aws regions
  is_multi_region_trail = true

  # enable log file validation to detect tampering
  enable_log_file_validation = true


  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  tags = var.cloudtail_tags

}

resource "random_integer" "bucket_suffix" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "aws_logs" {
  bucket        = "${var.company_name}-${random_integer.bucket_suffix.result}"
  force_destroy = true

  tags = var.s3_tags
}


locals {
  bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.aws_logs.bucket}"

  cloudtrail_logs_path = var.s3_key_prefix == "" ? "AWSLogs" : "${var.s3_key_prefix}/AWSLogs"

  cloudtrail_account_resources = toset(formatlist("${local.bucket_arn}/${local.cloudtrail_logs_path}/%s/*", [data.aws_caller_identity.current.account_id]))

  cloudtrail_resources = local.cloudtrail_account_resources
}

data "aws_iam_policy_document" "main" {
  statement {
    sid       = "cloudtrail-logs-get-bucket-acl"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [local.bucket_arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "cloudtrail-logs-put-object"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = local.cloudtrail_resources
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "aws_logs" {
  bucket = aws_s3_bucket.aws_logs.id
  policy = data.aws_iam_policy_document.main.json
}


