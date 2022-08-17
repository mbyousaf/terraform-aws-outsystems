###Generic Vars###
variable "region" {
  default = "eu-west-1"
}
variable "keypair" {
  default = ""
}
variable "ec2_private_subnets" {
  type    = list(any)
  default = []
}
variable "ec2_public_subnets" {
  type    = list(any)
  default = []
}
variable "vpc_id" {
  default = ""
}
variable "cidr_blocks" {
  default = ""
}
variable "environment" {
  default = "dev"
}
variable "client" {
  default = "ADA"
}
variable "iam_instance_profile_ec2" {
  default = ""
}

###Deployment Controller vars###
variable "os_dc_ec2_count" {
  type    = number
  default = "1"
}
variable "os_dc_ami_id" {
  default = "ami-0bdccab4f28cb48db"
}
variable "os_dc_instance_type" {
  default = "m4.xlarge"
}
variable "OSDevelopmentVersion" {
  type        = string
  description = "Service Studio version to install"
  default     = "11.14.16.60354"
}
variable "OSPlatformVersion" {
  type        = string
  description = "Platform version to install"
  default     = "11.16.0.35766"
}

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

###JumpServer vars###
variable "os_js_ec2_count" {
  type    = number
  default = "1"
}
variable "os_js_ami_id" {
  default = "ami-0bdccab4f28cb48db"
}
variable "os_js_instance_type" {
  default = "t3.medium"
}

###elb vars###
variable "elb_ssl_cert" {
  type    = string
  default = ""
}
variable "alb_public_subnets" {
  type    = list(any)
  default = []
}

###RDS vars###
variable "rds-storage" {
  default = "1000"
}
variable "rds-engine" {
  default = "sqlserver-se"
}
variable "rds-engine-version" {
  default = "15.00.4043.16.v1"
}
variable "rds-license-model" {
  default = "license-included"
}
variable "rds-instance-type" {
  default = "db.m5.large"
}
variable "multi-az" {
  default = "false"
}
variable "skip-final-snapshot" {
  default = "true"
}
variable "rds_private_subnets" {
  type    = list(any)
  default = []
}
