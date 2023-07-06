variable "aws_region" {
  default = "us-west-2"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket without the www. prefix. Normally domain_name."
}