# main.tf
provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
            Effect = "Allow"
        }]
    })
}

resource "aws_iam_policy" "lambda_cloudwatch_logs" {
    name        = "LambdaCloudWatchLogsPolicy"
    description = "Policy for Lambda to write logs to CloudWatch"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
    policy_arn = aws_iam_policy.lambda_cloudwatch_logs.arn
    role       = aws_iam_role.lambda_role.name  # Replace with your Lambda role name
}

resource "aws_lambda_function" "my_lambda" {
    function_name = "workshop_serverless_backend"
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.10"

    role          = aws_iam_role.lambda_role.arn
    filename      = "lambda_function.zip"

    source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.my_lambda.function_name
  authorization_type = "NONE"
}