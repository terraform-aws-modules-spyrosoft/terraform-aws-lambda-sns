locals {
  lambda_role_policies = merge(
    var.lambda_role_policies != null ? var.lambda_role_policies : {},
    {
      "SnsTaskPolicyLog" = jsonencode({
        Version : "2012-10-17",
        Statement = [
          {
            Effect = "Allow",
            Action = [
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:PutLogEvents"
            ],
            Resource = "*"
          }
        ]
      })
    }
  )
}

module "sns_lambda" {
  source = "terraform-aws-modules-spyrosoft/lambda/aws"

  function_name = var.lambda_name
  description   = var.lambda_description
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  s3_existing_package = var.lambda_s3_existing_package

  tags                  = var.tags
  environment_variables = var.lambda_environment_variables

  lambda_role = aws_iam_role.sns_lambda.arn
  layers      = var.lambda_layers

  cloudwatch_logs_retention_in_days = var.lambda_cloudwatch_logs_retention_in_days
  cloudwatch_logs_tags              = var.tags

  # Modules resources
  create_package = false
  create_role    = false
}

resource "aws_iam_role" "sns_lambda" {
  name               = var.lambda_role_name
  assume_role_policy = var.lambda_assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role_policy" "sns_lambda" {
  for_each = local.lambda_role_policies

  name   = each.key
  role   = aws_iam_role.sns_lambda.id
  policy = each.value
}

resource "aws_lambda_permission" "sns_lambda" {
  statement_id  = "AllowExecutionFromSnsQueue"
  action        = "lambda:InvokeFunction"
  function_name = module.sns_lambda.lambda_function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
  depends_on    = [module.sns_lambda]
}

resource "aws_sns_topic_subscription" "sns_lambda" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = module.sns_lambda.lambda_function_arn
}
