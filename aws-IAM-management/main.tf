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
  # Creating list
  user_role_pair = flatten([for user in local.users_data : [for role in user.roles : {
    username = user.username
    role     = role
  }]])
}

output "output" {
  value = local.user_role_pair
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

#Attaching Policies
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }
  user       = aws_iam_user.username[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}

