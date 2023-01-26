variable "region" {}
variable "keypair" {}
variable "ec2_private_subnets" {}
variable "ec2_public_subnets" {}
variable "vpc_id" {}
variable "cidr_blocks" {}
variable "environment" {}
variable "iam_instance_profile_ec2" {}
variable "os_dc_ami_id" {}
variable "os_dc_instance_type" {}
variable "OSDevelopmentVersion" {}
variable "OSPlatformVersion" {}

variable "elb_ssl_cert" {}
variable "alb_public_subnets" {}

variable "rds-storage" {}
variable "rds-engine-version" {}
variable "multi-az" {}
variable "skip-final-snapshot" {}
variable "rds_private_subnets" {}
variable "rds_instance_type" {}

# ###FrontEnd vars###
# variable "os_fe_ec2_count" {
#   type    = number
#   default = "1"
# }
# variable "os_fe_ami_id" {
#   default = "ami-0bdccab4f28cb48db"
# }
# variable "os_fe_instance_type" {
#   default = "m4.xlarge"
# }
