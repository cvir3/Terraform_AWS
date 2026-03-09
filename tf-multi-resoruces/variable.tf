variable "region" {
  description = "Value of region"
  type        = string
  default     = "ap-south-1"
}

/* This is for count */

# variable "ec2_config" {
#   type = list(object({
#     ami           = string
#     instance_type = string
#   }))
# }


/* This is for for_each */
variable "ec2_map" {
  # key = value [Value part is object (object is ami, instances)]
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
