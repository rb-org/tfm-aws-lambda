resource "aws_s3_bucket" "private" {
  bucket = "${local.prv_bucket_name}"
  region = "${var.region}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = "${merge(
    var.default_tags,
    map(
      "Workspace", format("%s", terraform.workspace)
    )
  )}"
}
