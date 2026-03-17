# IAM User Creation and Permission Assignment

The configuration reads user details and role information from a YAML file, which is converted into Terraform-readable data using the yamldecode() function. This allows user and role configurations to be maintained in a clean and easy-to-manage YAML format.

The flatten() function is used to transform nested data structures into a simple list format so Terraform can 
iterate through the values efficiently when creating resources.

## What this project does
- Reads IAM user configuration from a YAML file
- Uses yamldecode() to convert YAML data into Terraform objects
- Uses flatten() to simplify nested user-role structures
- Creates IAM users dynamically
- Generates login passwords for users
- Creates role-based permissions
- Assigns IAM policies to users based on their roles

## Key Features
- Dynamic user creation using Terraform loops
- Role-based permission assignment for better access management
- Centralized configuration using YAML for easier updates
- Scalable structure to manage multiple users and roles

## ➤ What is yamldecode?
yamldecode is a built-in function in Terraform. It converts YAML formatted data into a Terraform data structure (like map, list, or object) so Terraform can use it inside configuration.

OR

yamldecode() reads YAML content and converts it into Terraform readable values.

## Why yamldecode is used?
Many tools (Kubernetes, CI pipelines, configuration files) use YAML format. Terraform mainly works with HCL structures such as maps and lists.

- yamldecode helps you:
  - Read YAML files
  - Convert them into Terraform variables
  - Use that data to create resources dynamically

➦ We can use function yamldecord,
```bash
locals {
  users_data = yamldecode(file("./users.yaml"))
}
output "output" {
  value = local.users_data
}
```
> Output
```bash
Changes to Outputs:
  + output = {
      + users = [
          + {
              + role     = "dev"
              + username = "devuser"
            },
          + {
              + role     = "qa"
              + username = "qauser"
            },
          + {
              + role     = "ec2allaccess"
              + username = "superadmin"
            },
        ]
    }

```
It has converted it in the form of as a list.

-> we can use .user, means extract the data of these users only.
```bash
locals {
  users_data = yamldecode(file("./users.yaml")).users
}
output "output" {
  value = local.users_data
}
```
> Output
```bash
Changes to Outputs:
  + output = [
      + {
          + role     = "dev"
          + username = "devuser"
        },
      + {
          + role     = "qa"
          + username = "qauser"
        },
      + {
          + role     = "ec2allaccess"
          + username = "superadmin"
        },
    ]
```
Here we got a list. 

-> we want to get only username list
```bash
locals {
  users_data = yamldecode(file("./users.yaml")).users
}

output "output" {
  value = local.users_data[*].username
}
```
> Output
```bash
Changes to Outputs:
  + output = [
      + "devuser",
      + "qauser",
      + "superadmin",
    ]
```
## ➤ What is Flatten Function?
In Terraform, flatten() is a built-in function used to simplify nested lists. It is very useful when working with loops, dynamic resources, or complex variables.

Or 

flatten() converts a list of lists into a single list.
In simple terms, it removes one level of nesting from a list.

## Why use flatten()?
We use flatten() when our data structure contains nested lists, but Terraform resources usually require a single list.
- Common reasons
  - Convert nested lists into a single list
  - Prepare data for for_each or count
  - Work with complex variables
  - Simplify dynamic resource creation

Without flattening, Terraform may not understand how to iterate properly.

## Where do we use flatten()?
- flatten() is mostly used in:
  - for loops
  - for_each
  - complex variables
  - modules
  - dynamic resource generation



# How Create username and password in main.tf file
```bash
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
```
# How to assign policies for user in main.tf
```bash
#Attaching Policies
resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }
  user       = aws_iam_user.username[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}

```


# How to create a YAML file for usernames with role-based access
Basic
```bash
users:
  - username: devuser
    roles: dev
  - username: qauser
    roles: qa
  - username: superadmin
    roles: ec2allaccess
```
or
```bash
users:
  - username: devuser
    roles: [AmazonEC2FullAccess]
  - username: qauser
    roles: [AmazonS3ReadOnlyAccess,AmazonEC2FullAccess]
  - username: superadmin
    roles: [AdministratorAccess]
```
Multiple roles assigned
```bash
users:
  - username: devuser
    roles: [AmazonEC2FullAccess]
  - username: qauser
    # Multiple roles assigned
    roles: [AmazonS3ReadOnlyAccess,AmazonEC2FullAccess]
  - username: superadmin
    roles: [AdministratorAccess]
```

## Reference Links

[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile]()
[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment]()