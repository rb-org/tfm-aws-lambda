resource "aws_s3_bucket" "main" {
  bucket        = "${local.bucket_name}"
  region        = "${var.region}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = false
  }

  tags = "${merge(
    var.default_tags,
    map(
      "Workspace", format("%s", terraform.workspace)
    )
  )}"
}
