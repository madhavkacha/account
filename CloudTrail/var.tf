
variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group that receives CloudTrail events."
  default     = "cloudtrail-events"
  type        = string
}

variable "company_name" {
  description = "Enter Name for S3 bucket that prefix with company name"
  type = string
}

variable "trail_name" {
  description = "Name for the Cloudtrail"
  default     = "cloudtrail"
  type        = string
}

variable "iam_role_name" {
  description = "Name for the CloudTrail IAM role"
  default     = "cloudtrail-cloudwatch-logs-role"
  type        = string
}

variable "iam_policy_name" {
  description = "Name for the CloudTrail IAM policy"
  default     = "cloudtrail-cloudwatch-logs-policy"
  type        = string
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail logs"
  default     = "cloudtrail"
  type        = string
}



variable "s3_tags" {
  description = "A mapping of tags to S3 resources."
  default     = {}
  type        = map(string)
}

variable "cloudtail_tags" {
  description = "A mapping of tags to CloudTrail resources."
  default = {
    Name        = "CloudTrail"
    Environment = "Test"
  }
  type = map(string)
}
