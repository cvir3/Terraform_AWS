terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "6.32.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"  
}

resource "aws_s3_bucket" "test-demo" {
    # test-demo is configuration block name
    bucket = "first-s3-bucket-2026"
    # this is first-s3-bucket-2026 bucket name     
}

resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.test-demo.bucket
    source = "./myfile.txt"
    key = "mydata.txt"  
}
