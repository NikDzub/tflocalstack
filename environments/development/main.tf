terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = var.region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

data "aws_caller_identity" "current" {}
output "is_localstack" {
  value = data.aws_caller_identity.current.id == "000000000000"
}

module "vpc" {
  source                    = "../../modules/vpc"
  region                    = var.region
  project_name              = var.project_name
  vpc_cidr                  = var.vpc_cidr
  public_sub_az1_cidr       = var.public_sub_az1_cidr
  public_sub_az2_cidr       = var.public_sub_az2_cidr
  private_app_sub_az1_cidr  = var.private_app_sub_az1_cidr
  private_app_sub_az2_cidr  = var.private_app_sub_az2_cidr
  private_data_sub_az1_cidr = var.private_data_sub_az1_cidr
  private_data_sub_az2_cidr = var.private_data_sub_az2_cidr
}

module "nat_gateway" {
  source                  = "../../modules/nat_gateway"
  vpc_id                  = module.vpc.vpc_id
  internet_gateway        = module.vpc.internet_gateway
  pub_sub_az1_id          = module.vpc.pub_sub_az1_id
  pub_sub_az2_id          = module.vpc.pub_sub_az2_id
  private_app_sub_az1_id  = module.vpc.private_app_sub_az1_id
  private_app_sub_az2_id  = module.vpc.private_app_sub_az2_id
  private_data_sub_az1_id = module.vpc.private_data_sub_az1_id
  private_data_sub_az2_id = module.vpc.private_data_sub_az2_id
}
