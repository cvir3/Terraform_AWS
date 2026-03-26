# Creating Custom Terraform VPC Module
--- 
## What is Modules
- A module is a container of Terraform configuration files that you use to create and manage resources as a group.

#### ⤷ Types of Modules
1. Root Module
    - The main folder where you run Terraform
    - Contains main.tf, variables.tf, etc.
2. Child Module
    - A module called by another module
    - Stored locally or remotely

#### ⤷ Module Structure Example
```bash
project/
│
├── main.tf          # Root module
├── variables.tf
│
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

```
## How Module Works (Flow)
- Define module code (child module)
- Call module in root module
- Pass variables as input
- Module creates resources
- Output values if needed

#### ⤷ Key Components
| Component   | Purpose                 |
| ----------- | ----------------------- |
| `source`    | Where module is located |
| `variables` | Input values            |
| `outputs`   | Return values           |

#### ⤷ Short Analogy
- Module = Function
- Variables = Parameters
- Outputs = Return values

## When to Use Modules
Use modules when:
- You repeat same resources (EC2, VPC, S3)
- You want clean project structure
- You work in team (standardization needed)

#### ⤷ Repeated Resources (Most Common Use)
➤ **Without module**
```bash
resource "aws_instance" "web1" { ... }
resource "aws_instance" "web2" { ... }
resource "aws_instance" "web3" { ... }
```
➤ **With module**
```bash
module "ec2_instances" {
  source = "./modules/ec2"

  instance_count = 3
}
```
#### ⤷ Complex Infrastructure (Best Practice)
- When your setup includes multiple related resources.
- Example: VPC setup
    - VPC
    - Subnets
    - Internet Gateway
    - Route Tables

➤ **Create module**
```bash
modules/vpc/
```
➤ **Then use**
```bash
module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
}
```
#### ⤷ Multi-Environment Setup (Dev / QA / Prod)
```bash
module "dev_vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "prod_vpc" {
  source = "./modules/vpc"
  cidr_block = "192.168.0.0/16"
}
```
**Use module when:**
- You want consistency across environments
- Only variables change
---
## What is Validation?
- Validation is checking if input/data follows expected rules before using it.

```bash
validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Invalid CIDR Format"
  }

```
#### ⤷ This is Complex object validation
```bash
variable "vpc_config" {
  description = "To get the CIDR and Name of VPC from user"
  type = object({
    cidr_block = string
    name       = string
  })
  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Invalid CIDR Format"
  }
}
```
**If you want to check in output**
```bash
error_message = "Invalid CIDR Format - ${var.vpc_config.cidr_block}"
```
**These are the optional validations**
#### ⤷ Allowed Values
```bash
variable "instance_type" {
  type = string

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Invalid instance type."
  }
}
```
#### ⤷ Length / Count Validation
```bash
variable "subnets" {
  type = list(string)

  validation {
    condition     = length(var.subnets) >= 2
    error_message = "At least 2 subnets required."
  }
}
```
#### ⤷ Regex Validation
```bash
variable "env" {
  type = string

  validation {
    condition     = can(regex("^(dev|qa|prod)$", var.env))
    error_message = "Environment must be dev, qa, or prod."
  }
}
```
## CIDR Validation – Description Notes
- This logic is used to validate multiple CIDR blocks provided as input and ensure that all values follow the correct CIDR format before proceeding further.

- The system receives multiple CIDR blocks, typically from a configuration such as a subnet configuration list. Each CIDR block is validated individually to check whether it is in a proper and acceptable format.

- For each CIDR value, a validation function is applied. This function attempts to interpret the CIDR block and returns.

    - **true** if the CIDR format is valid
    - **false** if the CIDR format is invalid

- Instead of stopping execution on the first invalid CIDR, the system evaluates all CIDR blocks and stores their validation results in a list of boolean values (true/false).

- Once all CIDR blocks are validated, a final check is performed using a function like alltrue(). This function determines whether all values in the list are true.

    - If all **CIDR blocks are valid** → the input is accepted
    - If any **CIDR block is invalid** → the input is rejected with an error

- This approach ensures:
    - Complete validation of all inputs
    - Better error handling without abrupt failures
    - Clean and scalable validation logic for multiple CIDR entries

## What is ternary operator
- The ternary operator is a short, inline way to write a simple if-else condition in a single line.
```bash
condition ? expression_if_true : expression_if_false

> 0 ? 1 : 0
```
#### ⤷ How it works
- First, the condition is evaluated
- If it is **true** → returns expression_if_true
- If it is **false** → returns expression_if_false

#### ⤷ Simple Example
```bash
let age = 18;

let result = (age >= 18) ? "Adult" : "Minor";
console.log(result);
```
**Output**
```bash
Adult
```
#### ⤷ Equivalent if-else
```bash
let result;

if (age >= 18) {
  result = "Adult";
} else {
  result = "Minor";
}
```
## Why use ternary operator?
- Makes code short and clean
- Good for simple conditions
- Not recommended for complex logic (reduces readability)

## Example in DevOps / Terraform style thinking
- Even though Terraform doesn’t call it “ternary operator” explicitly like JS, it supports conditional expressions.
```bash
instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
```
**Meaning**
- If If environment is prod → use t3.large
- Else → use t3.micro

---
# Task Requirements
- Accept cidr_block from user to create VPC
- User can create multiple subnets
	- Get CIDR block for subnet from user
	- Get AZS (availability zone)
	- User can mark a subnet as public(default is private)
		- If public, create IGW
		- Associate public subnet with Routing table.