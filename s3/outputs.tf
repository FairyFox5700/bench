output "bench_execution_result_backet_id" {
  value       = aws_s3_bucket.bench_execution_results.id
  description = "The id of bench_execution_results backet"
}

output "python_code_dep_backet_id" {
  value       = aws_s3_bucket.python_code_dep.arn
  description = "The id of python_code_dep backet"
}

output "s3_bench_processing_results_id" {
  value       = aws_s3_bucket.s3_bench_processing_results.id
  description = "The id of s3_bench_processing_results backet"
}