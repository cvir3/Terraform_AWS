terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "6.32.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {
    region = "ap-south-1"  
}

resource "random_id" "rando_id" {
    byte_length = 8
  
}

resource "aws_s3_bucket" "test-demo" {
    # test-demo is configuration block name
    bucket = "first-s3-buckets-${random_id.rando_id.hex}"
    # this is first-s3-bucket-2026 bucket name     
}

output "uniqueId" {
    value = random_id.rando_id
  
}

/* This is for create s3 bucket
resource "aws_s3_bucket" "test-demo" {
    # test-demo is configuration block name
    bucket = "first-s3-bucket-2026"
    # this is first-s3-bucket-2026 bucket name     
} */


/* This is for upload file
resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.test-demo.bucket
    source = "./myfile.txt"
    key = "mydata.txt"  
}
*/

