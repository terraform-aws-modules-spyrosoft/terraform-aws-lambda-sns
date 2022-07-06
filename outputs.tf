# Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.sns_lambda.lambda_function_arn
}

output "lambda_name" {
  description = "Lambda name"
  value       = module.sns_lambda.lambda_function_name
}

output "lambda_function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = try(module.sns_lambda.lambda_function_source_code_hash, "")
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda Function"
  value       = module.sns_lambda.lambda_role_arn
}

# CloudWatch Log Group
output "lambda_cloudwatch_log_group_arn" {
  description = "The ARN of the Cloudwatch Log Group"
  value       = module.sns_lambda.lambda_cloudwatch_log_group_arn
}

output "lambda_cloudwatch_log_group_name" {
  description = "The name of the Cloudwatch Log Group"
  value       = module.sns_lambda.lambda_cloudwatch_log_group_name
}

# SNS info
output "sns_topic_name" {
  description = "The name of the SNS topic"
  value       = aws_sns_topic_subscription.sns_lambda.id
}

output "sns_arn" {
  description = "ARN SNS"
  value       = aws_sns_topic_subscription.sns_lambda.id
}
