variable "bench_execution_result_backet_id" {
  type        = string
  description = "Id of the benchmark execution result backet"
}

variable "python_code_dep_backet_id" {
  description = "Id of the python code dep backet"
  type        = string
}

variable "s3_bench_processing_results_id" {
  description = "Id of the s3 benchmark processing results"
  type        = string
}
