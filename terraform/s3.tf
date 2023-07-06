################# S3 #################

########### Website bucket ###########
/* resource "aws_s3_bucket" "www_bucket" {
  bucket = var.bucket_name

  lifecycle {
    ignore_changes = [
      website
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}", "https://${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "www_bucket" {
  bucket = aws_s3_bucket.www_bucket.bucket

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.www_bucket.bucket}/*"
        }
  ]

}
EOT

  depends_on = [
    aws_s3_bucket_public_access_block.www_bucket,
  ]
} */

# Reference existing S3 bucket created by back-end script
data "aws_s3_bucket" "www_bucket" {
  bucket = var.bucket_name
}

# Add website files to www S3 Bucket
resource "aws_s3_object" "www_bucket_upload" {
  bucket = data.aws_s3_bucket.www_bucket.id

  for_each = fileset("../stevenhoward.net", "**")

  key          = each.value
  content_type = lookup(local.content_type_map, split(".", "../stevenhoward.net/${each.value}")[2], "text/html")
  source       = "../stevenhoward.net/${each.value}"
  etag         = filemd5("../stevenhoward.net/${each.value}")
}

locals {
  content_type_map = {
    "js"   = "application/json"
    "html" = "text/html"
    "css"  = "text/css"
  }
}