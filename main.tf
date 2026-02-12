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

resource "aws_instance" "myserver" {
    // AMI ID identifies the OS image and its configuration used for EC2. 
    ami = "ami-019715e0d74f695be" 
    instance_type = "t3.micro"  

    tags = {
        Name = "SampleServer"
    }
}