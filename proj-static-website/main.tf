terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_s3_bucket" "mywebapp-bucket" {
  bucket = "mywebapp-s3-buckets-tfs"
  # this is first-s3-bucket-2026 bucket name     
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id
    # We are defining the policy in HCL and converting it to JSON using jsonencode().
    # This avoids writing raw JSON and removes the need to escape quotes or interpolate variables manually.
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.mywebapp-bucket.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"
  # Without setting content_type, the browser may download the file when opening the URL.
  # When content_type is set to "text/html", the browser renders the file as a web page instead of downloading it.
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.mywebapp-bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
  content_type = "text/css"
}

output "print_URL" {
    value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint  
}