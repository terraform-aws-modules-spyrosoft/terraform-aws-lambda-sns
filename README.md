# SNS lambda task

A Terraform module that creates a lambda for a SNS task

The lambda code must be zipped and sent to the S3 bucket.

## Usage

### A SNS task

The most common use-case that creates the sample lambda is triggered by SNS message.

```hcl
module "sns_lambda" {
  source = "terraform-aws-modules-spyrosoft/lambda-sns/aws"

  lambda_name        = "sns_lambda"
  lambda_handler     = "lambda_function.lambda_handler"
  lambda_runtime     = "python3.9"
  lambda_memory_size = 128
  lambda_timeout     = 30

  lambda_s3_existing_package = {
    bucket = "sns-lambda-bucket"
    key    = "sns_lambda_example.zip"
  }

  lambda_role_name                         = "SnsTaskExample"
  lambda_cloudwatch_logs_retention_in_days = 14

  sns_topic_arn = "my_sns_topic_subscription"
}
```
