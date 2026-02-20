terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.32.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"  
}

# Create a VPC
resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }  
}

#Private Subnet
resource "aws_subnet" "private-subnet" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my-vpc.id  
    tags = {
        Name = "private-subnet"
    }
}

#Public Subnet
resource "aws_subnet" "public-subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "public-subnet"
    }  
}

#Internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}

#Routing table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id

    #Create rules
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }  
}

#Subnet Accociation
resource "aws_route_table_association" "public-sub" {
    route_table_id = aws_route_table.my-rt.id
    subnet_id = aws_subnet.public-subnet.id  
}

#Create EC2 Instance
resource "aws_instance" "myserver" {
    ami = "ami-0317b0f0a0144b137"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet.id
    tags = {
      Name = "VP_SampleServer"
    }
  
}