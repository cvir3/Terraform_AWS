/* This is for count */
# ec2_config = [
#   {
#     ami           = "ami-019715e0d74f695be" #ubuntu
#     instance_type = "t3.micro"
#   },
#   {
#     ami           = "ami-0f559c3642608c138" #amazon linux
#     instance_type = "t3.micro"
# }]

/* This is for for_each */
ec2_map = {
  # key=value
  # ubuntu is key, and Object so object are values like ami, instance
  "ubuntu" = {
    ami           = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
  },
  "amazon-linux" = {
    ami           = "ami-0f559c3642608c138"
    instance_type = "t3.micro"
  }
}


