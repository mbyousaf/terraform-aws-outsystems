#Deploys the Outsystems Deployment controller and applied user data to the set of EC2's for the outssytems platform

data "template_file" "os-user-data-dc" {
  template   = "<powershell>${file("${path.module}/user-data-dc.ps1")}</powershell>"
  depends_on = [aws_lb.Outsystems-alb]
  vars = {
    PlatformVersion    = "${var.OSPlatformVersion}"
    DevelopmentVersion = "${var.OSDevelopmentVersion}"
  }
}

resource "aws_instance" "outsystems-dc" {
  count                  = var.os_dc_ec2_count
  ami                    = var.os_dc_ami_id
  instance_type          = var.os_dc_instance_type
  subnet_id              = element(var.ec2_private_subnets, count.index)
  vpc_security_group_ids = ["${aws_security_group.dc_ec2_sg.id}"]
  key_name               = var.keypair
  iam_instance_profile   = var.iam_instance_profile_ec2
  user_data              = data.template_file.os-user-data-dc.rendered
  root_block_device {
    volume_size = "250"
    encrypted   = "true"
  }
  tags = {
    Name        = "${var.environment}-ada-outsystems-deployment-controller"
    Environment = "${var.environment}"
    Client      = "${var.client}"
  }
}

#Deploys the Outsystems front end server(s) and applies user data for platform to be installed.

# data "template_file" "os-user-data-fe" {
#   template   = "<powershell>${file("${path.module}/user-data-fe.ps1")}</powershell>"
#   depends_on = [aws_lb.Outsystems-alb]
#   vars = {
#     PlatformVersion    = "${var.OSPlatformVersion}"
#     DevelopmentVersion = "${var.OSDevelopmentVersion}"
#   }
# }

# resource "aws_instance" "outsystems-fe" {
#   count                  = var.os_fe_ec2_count
#   ami                    = var.os_fe_ami_id
#   instance_type          = var.os_fe_instance_type
#   subnet_id              = element(var.ec2_private_subnets, count.index)
#   vpc_security_group_ids = ["${aws_security_group.FE-ec2-sg.id}"]
#   user_data              = data.template_file.os-user-data-fe.rendered
#   key_name               = var.keypair
#   iam_instance_profile   = var.iam_instance_profile_ec2
#   root_block_device {
#     volume_size = "250"
#     encrypted   = "true"
#   }
#   tags = {
#     Name        = "${var.environment}-ada-outsystems-frontend"
#     Environment = "${var.environment}"
#     Client      = "${var.client}"
#   }
# }

#Deploys the Outsystems jump server(s) and applies user data for platform to be installed.

# resource "aws_instance" "outsystems-js" {
#   count                       = var.os_js_ec2_count
#   ami                         = var.os_js_ami_id
#   instance_type               = var.os_js_instance_type
#   subnet_id                   = element(var.ec2_public_subnets, count.index)
#   vpc_security_group_ids      = ["${aws_security_group.js_ec2_sg.id}"]
#   key_name                    = var.keypair
#   iam_instance_profile        = var.iam_instance_profile_ec2
#   associate_public_ip_address = true
#   root_block_device {
#     volume_size = "250"
#     encrypted   = "true"
#   }
#   tags = {
#     Name        = "${var.environment}-ada-outsystems-jumpserver"
#     Environment = "${var.environment}"
#     Client      = "${var.client}"
#   }
# }



#Deploys the outsystems alb, target group, etc. attached to the EC2's.
#The elb traget group
resource "aws_lb_target_group" "Outsystems-lb-target-group" {
  health_check {
    interval            = 10
    path                = "/ServiceCenter/_ping.aspx"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "Outsystems-target-group"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

#The alb
resource "aws_lb" "Outsystems-alb" {
  name               = "${var.environment}-ada-outsystems-alb"
  internal           = "false"
  security_groups    = ["${aws_security_group.elb_sg.id}"]
  subnets            = var.alb_public_subnets
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  tags = {
    Environment = "${var.environment}"
    Client      = "${var.client}"
  }
}

#The alb listeners
resource "aws_lb_listener" "Outsystems-alb-listener" {
  load_balancer_arn = aws_lb.Outsystems-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.elb_ssl_cert
  default_action {
    target_group_arn = aws_lb_target_group.Outsystems-lb-target-group.arn
    type             = "forward"
  }
}
resource "aws_lb_listener" "Outsystems-alb-listener-80" {
  load_balancer_arn = aws_lb.Outsystems-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#The alb target group attachment
# resource "aws_alb_target_group_attachment" "ec2_attach" {
#   count            = length(aws_instance.outsystems-fe)
#   target_group_arn = aws_lb_target_group.Outsystems-lb-target-group.arn
#   target_id        = aws_instance.outsystems-fe[count.index].id
# }
resource "aws_alb_target_group_attachment" "ec2_attach-dc" {
  count            = length(aws_instance.outsystems-dc)
  target_group_arn = aws_lb_target_group.Outsystems-lb-target-group.arn
  target_id        = aws_instance.outsystems-dc[count.index].id
}

#Deploys the mssql RDS for Outsystems along with its components.

#The RDS
resource "aws_db_instance" "mssql-rds" {
  allocated_storage         = var.rds-storage
  storage_type              = "gp2"
  storage_encrypted         = "true"
  engine                    = var.rds-engine
  engine_version            = var.rds-engine-version
  license_model             = var.rds-license-model
  instance_class            = var.rds-instance-type
  multi_az                  = var.multi-az
  username                  = "root"
  password                  = random_password.password-os.result
  apply_immediately         = "true"
  skip_final_snapshot       = var.skip-final-snapshot
  backup_retention_period   = "7"
  copy_tags_to_snapshot     = "true"
  deletion_protection       = "false"
  db_subnet_group_name      = aws_db_subnet_group.mssql.name
  vpc_security_group_ids    = ["${aws_security_group.rds_sg.id}"]
  identifier                = "${var.environment}-ada-outsystems-os-mssql"
  parameter_group_name      = "default.sqlserver-se-15.0"
  option_group_name         = "${var.environment}-ada-sqlserver-se-15"
  depends_on                = [aws_db_option_group.optiongroup]
  port                      = "1433"
  final_snapshot_identifier = "abc"
  timeouts {
    create = "120m"
    delete = "2h"
  }
  tags = {
    Environment = "${var.environment}"
    Client      = "${var.client}"
  }
}

resource "random_password" "password-os" {
  length  = 16
  special = false
}
resource "aws_ssm_parameter" "secret" {
  name        = "/${var.environment}/outsystems/database/password/root"
  description = "Outsystems RDS root password"
  type        = "SecureString"
  value       = random_password.password-os.result
}

# The Subnet Group

resource "aws_db_subnet_group" "mssql" {
  name       = "${var.environment}-ada-outsystems-subnet-group"
  subnet_ids = var.rds_private_subnets
}

# The Option Group

resource "aws_db_option_group" "optiongroup" {
  name                     = "${var.environment}-ada-sqlserver-se-15"
  option_group_description = "Option group for SQL server 15 SE with backups"
  engine_name              = "sqlserver-se"
  major_engine_version     = "15.00"
}