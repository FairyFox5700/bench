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
