terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  users_data = yamldecode(file("./users.yaml")).users
}

output "output" {
  value = local.users_data[*].username
}

# Creating users
resource "aws_iam_user" "username" {
  for_each = toset(local.users_data[*].username)
  name     = each.value
}

# Password creation
resource "aws_iam_user_login_profile" "password" {
  for_each        = aws_iam_user.username
  user            = each.value.name
  password_length = 9
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}


