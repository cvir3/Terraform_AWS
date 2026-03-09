# Terraform Multi Resources Using FOR EACH

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