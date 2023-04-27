terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }

}

provider "aws" {
    region = "eu-west-1"
}



module "ec2" {
  source   = "./ec2"
}

# Create S3 bucket
module "s3" {
  source      = "./s3"
  environment = var.environment
  region = "eu-west-1"
}

#lamda handler

module "lambda" {
  source = "./lambda"
  bucket_trigger_id = module.s3.bench_execution_results_id
}

