variable "bench_execution_result_backet_id" {
  value       = aws_s3_bucket.bench_execution_results.id
  type        = string
}

variable "python_code_dep_backet_id" {
  value       = aws_s3_bucket.python_code_dep.id
  type        = string
}

variable "s3_bench_processing_results_id" {
  value       = aws_s3_bucket.s3_bench_processing_results.id
  type        = string
}
