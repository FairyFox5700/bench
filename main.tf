terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

     local = {
      version = "~> 2.1"
    }
  }
  backend "s3" {
    bucket = "terraform-state-dev-bench"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Create S3 bucket
module "s3" {
  source      = "./s3"
  environment = var.environment
  region      = "eu-west-1"
}

#lamda handler
module "lambda" {
  source = "./lambda"
  s3_bench_processing_results_id = module.s3.s3_bench_processing_results_id
  python_code_dep_backet_id= module.s3.python_code_dep_backet_id
  bench_execution_result_backet_id = module.s3.bench_execution_result_backet_id
}
module "ec2" {
  source   = "./ec2"
}
module "iam" {
  source = "./iam"
}
