#security-group.tf
#This template defines the security groups for the outsystems EC2's, ABL and RDS.

###The Deployment Controller EC2 Security Group###
resource "aws_security_group" "dc_ec2_sg" {
  name        = "${var.environment}-ada-outsystems-dc-sg"
  vpc_id      = var.vpc_id
  description = "Deployment controller ec2 sercurity group"
  ingress {
    #SSH using OpenVPN
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow SSH traffic on the VPN range"
  }
  ingress {
    #http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow http traffic on the VPN range"
  }
  ingress {
    #http
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow http traffic on the VPN range"
  }
  ingress {
    from_port       = 433
    to_port         = 433
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
    description     = "Load balancer access to OS server"
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
    description     = "Load balancer access to OS server"
  }
  ingress {
    from_port   = 12002
    to_port     = 12002
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow OS service communication"
  }
  egress {
    # all traffic outbound
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Deployment port
    from_port   = 12000
    to_port     = 12000
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow OS deployment communication"
  }
  ingress {
    #Deployment port
    from_port   = 12001
    to_port     = 12001
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow OS deployment communication"
  }
  ingress {
    #Deployment port
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow cache validation to controller server"
  }
  ingress {
    #RDS
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow SSH traffic on the VPN range"
  }
  ingress {
    #SSH using RDP
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    security_groups = ["${aws_security_group.js_ec2_sg.id}"]
    description     = "Allow RDP traffic from the JumpServer"
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name               = "${var.environment}-ada-outsystems-dc-sg"
    "APPID"            = ""
    "BILLINGCODE"      = ""
    "BILLINGCONTACT"   = "managedcloud@deloittecloud.uk"
    "CMS"              = ""
    "COUNTRY"          = "GB"
    "CSCLASS"          = "Confidential"
    "CSQUAL"           = ""
    "CSTYPE"           = ""
    "ENVIRONMENT"      = ""
    "FUNCTION"         = "CON"
    "MEMBERFIRM"       = "UK"
    "PRIMARYCONTACT"   = "managedcloud@deloittecloud.uk"
    "SECONDARYCONTACT" = "managedcloud@deloittecloud.uk"
  }
}

###The Front End EC2 Security Group###
# resource "aws_security_group" "FE-ec2-sg" {
#   vpc_id      = var.vpc_id
#   description = "FrontEnd ec2 sercurity group"
#   ingress {
#     #SSH
#     from_port   = 3389
#     to_port     = 3389
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow SSH traffic on the VPN range"
#   }
#   ingress {
#     #http
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow http traffic on the VPN range"
#   }
#   ingress {
#     #http
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow http traffic on the VPN range"
#   }
#   ingress {
#     from_port       = 433
#     to_port         = 433
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.elb-sg.id}"]
#     description     = "Load balancer access to OS server"
#   }
#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.elb-sg.id}"]
#     description     = "Load balancer access to OS server"
#   }
#   ingress {
#     from_port   = 12002
#     to_port     = 12002
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow OS service communication"
#   }
#   egress {
#     # all traffic outbound
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     # Deployment port
#     from_port   = 12000
#     to_port     = 12000
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow OS deployment communication"
#   }
#   ingress {
#     # Deployment port
#     from_port   = 12001
#     to_port     = 12001
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow OS deployment communication"
#   }
#   ingress {
#     # Deployment port
#     from_port   = 5672
#     to_port     = 5672
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow cache validation to controller server"
#   }
#   ingress {
#     #RDS
#     from_port   = 1433
#     to_port     = 1433
#     protocol    = "tcp"
#     cidr_blocks = ["10.2.0.0/16"]
#     description = "Allow SSH traffic on the VPN range"
#   }
#   lifecycle {
#     create_before_destroy = false
#   }
# }

###ELB-SG###
resource "aws_security_group" "elb_sg" {
  name        = "${var.environment}-ada-outsystems-elb-sg"
  vpc_id      = var.vpc_id
  description = "Load balancer security group"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow secure traffic publicly"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow secure traffic publicly"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name               = "${var.environment}-ada-outsystems-elb-sg"
    "APPID"            = ""
    "BILLINGCODE"      = ""
    "BILLINGCONTACT"   = "managedcloud@deloittecloud.uk"
    "CMS"              = ""
    "COUNTRY"          = "GB"
    "CSCLASS"          = "Confidential"
    "CSQUAL"           = ""
    "CSTYPE"           = ""
    "ENVIRONMENT"      = ""
    "FUNCTION"         = "CON"
    "MEMBERFIRM"       = "UK"
    "PRIMARYCONTACT"   = "managedcloud@deloittecloud.uk"
    "SECONDARYCONTACT" = "managedcloud@deloittecloud.uk"
  }
}
###RDS-SG###
resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-ada-outsystems-rds-sg"
  description = "Allow required traffic for RDS"
  vpc_id      = var.vpc_id

  ingress {
    #SSH
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow mssql traffic on the VPN range"
  }
  egress {
    # all traffic outbound
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name               = "${var.environment}-ada-outsystems-rds-sg"
    "APPID"            = ""
    "BILLINGCODE"      = ""
    "BILLINGCONTACT"   = "managedcloud@deloittecloud.uk"
    "CMS"              = ""
    "COUNTRY"          = "GB"
    "CSCLASS"          = "Confidential"
    "CSQUAL"           = ""
    "CSTYPE"           = ""
    "ENVIRONMENT"      = ""
    "FUNCTION"         = "CON"
    "MEMBERFIRM"       = "UK"
    "PRIMARYCONTACT"   = "managedcloud@deloittecloud.uk"
    "SECONDARYCONTACT" = "managedcloud@deloittecloud.uk"
  }
}

###The Jump Server EC2 Security Group###
resource "aws_security_group" "js_ec2_sg" {
  name        = "${var.environment}-ada-outsystems-js-sg"
  vpc_id      = var.vpc_id
  description = "Jump Server ec2 sercurity group"
  ingress {
    #SSH
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow SSH traffic on the VPN range"
  }
  ingress {
    #http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow http traffic on the VPN range"
  }
  ingress {
    #https
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
    description = "Allow http traffic on the VPN range"
  }
  egress {
    # all traffic outbound
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name               = "${var.environment}-ada-outsystems-js-sg"
    "APPID"            = ""
    "BILLINGCODE"      = ""
    "BILLINGCONTACT"   = "managedcloud@deloittecloud.uk"
    "CMS"              = ""
    "COUNTRY"          = "GB"
    "CSCLASS"          = "Confidential"
    "CSQUAL"           = ""
    "CSTYPE"           = ""
    "ENVIRONMENT"      = ""
    "FUNCTION"         = "CON"
    "MEMBERFIRM"       = "UK"
    "PRIMARYCONTACT"   = "managedcloud@deloittecloud.uk"
    "SECONDARYCONTACT" = "managedcloud@deloittecloud.uk"
  }
}
