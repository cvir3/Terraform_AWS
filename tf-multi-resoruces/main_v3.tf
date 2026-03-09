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

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project}-vpc"
  }
}

# Creating 2 subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}


# Creating EC2 instance
/*Create two subnets with EC2 instances using for_each(Ubuntu in Subnet 1 and Amazon Linux in Subnet 2)*/

resource "aws_instance" "main" {
  for_each = var.ec2_map
  # We will get each.key and each.value
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.main))

  tags = {
    Name = "${local.project}-instance-${each.key}"
  }
}
