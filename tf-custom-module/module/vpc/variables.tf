variable "vpc_config" {
  description = "To get the CIDR and Name of VPC from user"
  type = object({
    cidr_block = string
    name       = string
  })
  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "Invalid CIDR Format - ${var.vpc_config.cidr_block}"
  }
}

variable "subnet_config" {
  description = "Get the CIDR and AZ for the subnets"
  type = map(object({
    az         = string
    cidr_block = string
    #User can mark a subnet as public(default is private)
    public = optional(bool, false)

  }))
  validation {
    # sub1 ={cidr=} sub2 ={cidr=..}, [true, true, false]
    condition     = alltrue([for config in var.subnet_config : can(cidrnetmask(config.cidr_block))])
    error_message = "Invalid CIDR Format - ${var.vpc_config.cidr_block}"
  }
}
