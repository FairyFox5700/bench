resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-state-main-dev"
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning_example" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "s3_bench_processing_results" {
  bucket = "s3-bench-processing-results"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3_bench_processing_results_versioning" {
  bucket = aws_s3_bucket.s3_bench_processing_results.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "bench_execution_results" {
  bucket = "bench-execution-results-pipeline"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bench_execution_results_versioning" {
  bucket = aws_s3_bucket.bench_execution_results.id
  versioning_configuration {
    status = "Enabled"
  }
}

#python code dep layer

resource "aws_s3_bucket" "python_code_dep" {
  bucket = "python-code-dependencies-lambda"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "python_code_dep_versioning" {
  bucket = aws_s3_bucket.python_code_dep.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object" "s3code_object" {
  bucket = "python-code-dependencies-lambda"
  key    = "s3code.zip"
  source = "./python-lamda-s3-dependencies/s3code.zip"
}

resource "aws_s3_bucket_object" "python_object" {
  bucket = "python-code-dependencies-lambda"
  key    = "python.zip"
  source = "./python-lamda-s3-dependencies/python.zip"
}
