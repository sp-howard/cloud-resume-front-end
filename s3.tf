################# S3 #################

# Reference existing S3 bucket created by back-end script
data "aws_s3_bucket" "www_bucket" {
  bucket = var.bucket_name
}

# Upload website files to S3 bucket
resource "aws_s3_object" "www_bucket_upload" {
  bucket = data.aws_s3_bucket.www_bucket.id

  for_each = fileset("./stevenhoward.net/public", "**")

  key          = each.value
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  source       = "./stevenhoward.net/public/${each.value}"
  etag         = filemd5("./stevenhoward.net/public/${each.value}")
}

# Match file type to content type so that S3 can serve the files correctly
locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
    "xml"  = "application/xml"
    "jpg"  = "image/jpeg"
    "pdf"  = "application/pdf"
    "docx"  = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  }
}