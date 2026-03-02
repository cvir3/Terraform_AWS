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

data "aws_security_group" "name" {
  tags = {
    Name = "SG_Nginx"
  }
}

data "aws_vpc" "name" {
  tags = {
    Name = "my_vpc"
  }
}
#To get the zone lists
data "aws_availability_zones" "names" {
  state = "available"
}

resource "aws_instance" "Nginx-Server" {
  ami           = data.aws_ami.name.id
  instance_type = "t3.micro"

  tags = {
    Name = "Nginx-Server"
  }
}

#To get the account details
data "aws_caller_identity" "name" {

}

#To get the region
data "aws_region" "name" {

}

output "region_name" {
  value = data.aws_region.name
}

output "caller_info" {
  value = data.aws_caller_identity.name
}

output "aws_zones" {
  value = data.aws_availability_zones.names
}

output "security_group" {
  value = data.aws_security_group.name.id
}

output "vpc_id" {
  value = data.aws_vpc.name.id
}
