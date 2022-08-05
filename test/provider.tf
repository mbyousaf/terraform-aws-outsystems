terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.13.0"
    }
  }
  backend "s3" {
    bucket = "aws-tf-ada-bucket"
    key    = "hem_terraform_ada_outsystems_infra.tfstate"
    region = "eu-west-1"
    # dynamodb_table = "aws-tf-ada-statelock"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}