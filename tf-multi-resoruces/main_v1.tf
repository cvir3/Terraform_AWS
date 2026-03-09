terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  project = "project-01"
}

resource "aws_vpc" "mr-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project}-vpc"
  }
}

# Creating 2 subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.mr-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}


# Creating 4EC2 instance
/*create 4 ec2 instance, 2 in each subnet.*/

resource "aws_instance" "main" {
  ami           = "ami-051a31ab2f4d498f5"
  instance_type = "t3.micro"
  count         = 4
  subnet_id     = element(aws_subnet.main[*].id, count.index % length(aws_subnet.main))

  # 0%2 = 0 
  # 1%2 = 1
  # 2%2 = 0
  # 3%3 = 1

  tags = {
    Name = "${local.project}-instance-${count.index}"
  }

}

