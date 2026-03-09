variable "region" {
  description = "Value of region"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_config" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}
