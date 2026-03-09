# Terraform Multi Resources Using COUNT and FOR EACH

### What is count?

count is a meta-argument in Terraform used to create multiple copies of a resource.

```bash
resource "aws_instance" "example" {
  count = 3
}
```
Terraform will create:

```bash 
aws_instance.example[0]
aws_instance.example[1]
aws_instance.example[2]
```

### Why use count?
We use count when we want to Create multiple resources, Avoid repeating the same code, Dynamically create resources from a list

### Where is count used?
Common places such as  Creating multiple EC2 instances, Creating multiple subnets, Creating multiple security groups, Creating multiple load balancers.

```base 
resource "aws_subnet" "example" {
  count = 2
}
```

### What is length() in Terraform?
length() is a function used to count the number of elements in a list, string, or map.

### Why use length() in your code?
Your terraform.tfvars contains a list of EC2 configurations.
```base 
ec2_config = [
  {
    ami           = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
  },
  {
    ami           = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
  }
]
```
There are 2 objects in the list.
```bash 
length(var.ec2_config) = 2
```

### How count and length() work together
```base
count = length(var.ec2_config)
```
Step-by-step:

1) Terraform checks the list.
```base
var.ec2_config
```
2) length() calculates:
```base
length(var.ec2_config) = 2
```

3) Terraform sets:
```bash
count = 2
```
So Terraform creates:
```bash
aws_instance.main[0]
aws_instance.main[1]
```
Two EC2 instances.

### What is count.index?
count.index is a built-in variable in Terraform that represents the index number of a resource when multiple resources are created using the count meta-argument.

It works like an array index and always starts from 0.

When Terraform creates multiple instances of a resource using count, it assigns an index to each resource. The index increases by 1 for every resource created.

## Project Details
### Task 1:

the project is **creates two subnets and launches four EC2 instances, with two instances deployed in each subnet**.
- Subnet - 1 (10.0.1.0/24)
  - EC2-1
  - EC2-2

- Subnet - 2 (10.0.2.0/24)
  - EC2-3
  - EC2-4

> **[!NOTE]**
> This project configuration in main_v1.tf uses the count meta-argument along with the length() function. 

### Task 2:
Create Two Subnets with EC2 Instances (**Ubuntu in Subnet 1** and **Amazon Linux in Subnet 2**)
- Subnet - 1 (Ubuntu)
  - EC2-1
- Subnet - 2 (Amazon Linux)
  - EC2-3

> **[!NOTE]**
> This project configuration is written in the main_v2.tf file. It uses two additional files: variables.tf for variable declarations and terraform.tfvars for variable values.

### What is variables.tf?
**variables.tf** is used to define variables that your Terraform configuration will use.
```base
variable "ec2_config" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}
```
### Why we use variables.tf
- Declare inputs for Terraform.
- Define data type and structure.
- Make the code reusable.
- Separate configuration from values.

### What is terraform.tfvars?
**terraform.tfvars** is used to assign actual values to the variables defined in **variables.tf**.

```bash
ec2_config = [
  {
    ami           = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
  },
  {
    ami           = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
  }
]
```

### How they work together
Step 1. variables.tf declares the variable
```base
variable "ec2_config"
```
Step 2. terraform.tfvars provides the values
```base
ec2_config = [...]
```
Step 3. Terraform uses it in main.tf
```base
count = length(var.ec2_config)
```
Terraform reads the values like this.
```base
terraform.tfvars → variables.tf → main.tf
```
---

### What is for_each in Terraform?

for_each is a meta-argument used to create multiple instances of a resource or module using a map or set of values.

OR

for_each is used to create multiple Terraform resources using a map or set of values. Each resource instance is identified by a unique key using each.key and each.value

```bash
resource "aws_instance" "server" {
  for_each = {
    server1 = "t2.micro"
    server2 = "t2.small"
  }

  ami           = "ami-123456"
  instance_type = each.value
}
```
Terraform will create:

```bash 
| Key     | Instance Type |
| ------- | ------------- |
| server1 | t2.micro      |
| server2 | t2.small      |

```

### Why use for_each?
We use for_each when we want to create multiple resources with different values.
- Benefits
  - Each resource has a unique key
  - Manage resources easily
  - Easy to add or remove resources

### What is a Map in Terraform?
A map is a key-value pair data structure and Each value has a unique key.

```base 
instance_type = {
  dev  = "t2.micro"
  test = "t2.small"
  prod = "t2.medium"
}
```

```base 
| Key  | Value     |
| ---- | --------- |
| dev  | t2.micro  |
| test | t2.small  |
| prod | t2.medium |

```

### Why use Map?
Maps are useful when you want to store related values with a name (key).
- Benefits
  - Easy to reference using keys
  - Good for environment configuration
  - Works well with for_each

### Where do we use Map?
Maps are commonly used in variables, main and environment configuration.
1) Variables

```base 
variable "ec2_map" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
```
2) Main

```bash 
resource "aws_instance" "main" {
  for_each      = var.ec2_map
  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.main))

  tags = {
    Name = "${local.project}-instance-${each.key}"
  }
}
```
3) Environment configuration

```base
variable "region_map" {
  default = {
    india = "ap-south-1"
    us    = "us-east-1"
  }
}
```
## Project Details
### Task 1:
Create two subnets with EC2 instances using for_each (Ubuntu in Subnet 1 and Amazon Linux in Subnet 2)

**[!NOTE]**
> This project configuration in main_v3.tf uses the for_each meta-argument along with the length() function. 