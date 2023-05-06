variable "bench_execution_result_backet_id" {
  value       = var.bench_execution_results.id
  type        = string
}

variable "python_code_dep_backet_id" {
  value       = var.python_code_dep.id
  type        = string
}

variable "s3_bench_processing_results_id" {
  value       = var.s3_bench_processing_results.id
  type        = string
}
