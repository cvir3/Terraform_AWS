terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "6.32.0"
    }
  }
  backend "s3" {
    # Enter the bucket name. If the bucket already exists, copy the name from S3 and paste it here.
    bucket = "first-s3-buckets-2a378e8f2d050b45"
    # Enter the terraform.tfstate file name.
    key = "backend.tfstate"
    region = "ap-south-1"
    }
}

provider "aws" {
    # Here used the variable
    region = "ap-south-1" 
}

resource "aws_instance" "myserver" {
    # AMI ID identifies the OS image and its configuration used for EC2. 
    ami = "ami-0317b0f0a0144b137" 
    instance_type = "t3.micro"  

    tags = {
        Name = "V_SampleServer"
    }
}