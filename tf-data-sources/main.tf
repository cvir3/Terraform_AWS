terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.33.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
# This is for dynamic data (Data sources)
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
}

output "aws_ami" {
  # If you want to get details we can use this.
  # value = data.aws_ami.name

  # If you want to get only id we can use this.
  value = data.aws_ami.name.id
}

resource "aws_instance" "myserver" {
  ami           = data.aws_ami.name.id
  instance_type = "t3.micro"

  tags = {
    Name = "V_SampleServer"
  }
}
