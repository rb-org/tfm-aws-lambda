resource "aws_cloudtrail" "main" {
  name                          = "${local.ct_name}"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.ct_main.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.ct_main.arn}"
  enable_logging                = true
  is_multi_region_trail         = false
  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false
    data_resource {
      type = "AWS::S3::Object"

      # Make sure to append a trailing '/' to your ARN if you want
      # to monitor all objects in a bucket.
      values = ["${aws_s3_bucket.private.arn}/"]
    }
  }
  tags = "${merge(
    var.default_tags,
    map(
      "Workspace", format("%s", terraform.workspace)
    )
  )}"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${local.ct_bucket}"
  force_destroy = true
  policy        = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.ct_bucket}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.ct_bucket}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
