output "bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "Bucket Name (aka ID)"
}

# AWS s3 bucket arn
output "bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The arn of the bucket will be in format arn:aws:s3::bucketname"
}

output "bench_execution_results_id" {
  value       = aws_s3_bucket.bench_execution_results.id
  description = "The id of bench_execution_results backet"
}
