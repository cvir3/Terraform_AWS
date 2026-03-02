output "all_info" {
  value = {
    ami_id             = data.aws_ami.name.id
    region             = data.aws_region.name
    account_id         = data.aws_caller_identity.name.account_id
    security_group     = data.aws_security_group.name.id
    vpc_id             = data.aws_vpc.name.id
    availability_zones = data.aws_availability_zones.names.names
  }
}
