module "outsystems" {

  source = "../"

  keypair                  = var.keypair
  environment              = var.environment
  vpc_id                   = var.vpc_id
  iam_instance_profile_ec2 = var.iam_instance_profile_ec2
  ec2_private_subnets      = var.ec2_private_subnets
  ec2_public_subnets       = var.ec2_public_subnets
  elb_ssl_cert             = var.elb_ssl_cert
  alb_public_subnets       = var.alb_public_subnets
}