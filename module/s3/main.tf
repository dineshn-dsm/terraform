resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name
  acl = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  tags = {
    Name        = "${var.s3_tags}"
  }
}
