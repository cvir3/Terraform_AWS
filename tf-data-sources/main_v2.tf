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

# For use exsiting VPC
data "aws_vpc" "name" {
  tags = {
    Name = "my_vpc"
  }
}

# For use exsiting subnet
data "aws_subnet" "name" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.name.id]
  }
  tags = {
    Name = "private-subnet"
  }
}


#To get the zone lists
data "aws_availability_zones" "names" {
  state = "available"
}

# Create instance using exsiting vpc and subnet
resource "aws_instance" "myServer" {
  ami             = "ami-051a31ab2f4d498f5"
  instance_type   = "t3.micro"
  subnet_id       = data.aws_subnet.name.id
  security_groups = [data.aws_security_group.name.id]

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
