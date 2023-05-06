#s3 handler
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_s3_access" {
  name = "lambda_s3_access"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles = [aws_iam_role.lambda_role.name]
}

resource "aws_lambda_function" "python_s3_handler" {
    description = "Processing  s3 bucket bechmark csv outputs and combining them to one csv tabular format in another s3 bucket"
    function_name = "s3-python-benhcmark-output-processor-hadler"
    handler = "s3code.main.lambda_handler"
    architectures = [
        "x86_64"
    ]
    runtime = "python3.9"
    timeout = 300
    role = aws_iam_role.lambda_role.arn

    #s3 code source
    s3_bucket = var.python_code_dep_backet_id
    s3_key = "s3code.zip"
    source_code_hash = filebase64sha256("./python-lamda-s3-dependencies/s3code.zip")

    memory_size = 128

    # Lambda Layer and CloudWatch Logs (same as before)

    tracing_config {
        mode = "Active"
    }

    environment {
    variables = {
      "LOG_LEVEL" = "INFO"
    }
  }

    #layers
    layers = [aws_lambda_layer_version.pandas_layer.arn]

}

resource "aws_lambda_layer_version" "pandas_layer" {
    description = "pandas, numpy dependencies"
    compatible_runtimes = [
        "python3.9"
    ]
    layer_name = "pandas"

    #s3 bucket dependencies location
    s3_bucket = var.python_code_dep_backet_id
    s3_key = "python.zip"
  
}

resource "aws_cloudwatch_log_group" "my_lambda_logs" {
  name ="/aws/lambda/${var.s3_bench_processing_results_id}"
}

resource "aws_lambda_permission" "LambdaPermission" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.python_s3_handler.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "arn:aws:s3:::${var.bench_execution_result_backet_id}"
}

resource "aws_s3_bucket_notification" "my_bucket_notification" {
  bucket = var.bench_execution_result_backet_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.python_s3_handler.arn
    events              = ["s3:ObjectCreated:*"]
  }
}