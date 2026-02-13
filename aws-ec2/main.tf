terraform {
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "6.32.0"
    }
  }
}

provider "aws" {
    # Here used the variable
    region = var.region  
}

resource "aws_instance" "myserver" {
    # AMI ID identifies the OS image and its configuration used for EC2. 
    ami = "ami-0317b0f0a0144b137" 
    instance_type = "t3.micro"  

    tags = {
        Name = "V_SampleServer"
    }
}