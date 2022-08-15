###Generic Vars###
variable "region" {
  default = "eu-west-1"
}
variable "keypair" {
  default = "ec2-tableau"
}
variable "ec2_private_subnets" {
  type    = list(any)
  default = ["subnet-0e733f99bedfbd815", "subnet-0a262d0321e644fb6"]
}
variable "ec2_public_subnets" {
  type    = list(string)
  default = ["subnet-02e8004d05418ccbf", "subnet-0fafd21af22566bce"]
}
variable "vpc_id" {
  default = "vpc-0d116fb96a1dc6355"
}
variable "environment" {
  default = "dev"
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
  default = "m5.large"
}
variable "OSDevelopmentVersion" {
  type        = string
  description = "Service Studio version to install"
  default     = "11.8.3.24554"
}
variable "OSPlatformVersion" {
  type        = string
  description = "Platform version to install"
  default     = "11.11.2.29611"
}

###elb vars###
variable "elb_ssl_cert" {
  type    = string
  default = "arn:aws:acm:eu-west-3:749307286348:certificate/9017ff65-6c44-4da4-a42f-4917d2db956a"
}
variable "alb_public_subnets" {
  type    = list(any)
  default = ["subnet-02e8004d05418ccbf", "subnet-0fafd21af22566bce"]
}