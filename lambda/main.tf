resource "aws_lambda_function" "lambda_source_dir" {
  count = var.source_dir != "" ? 1 : 0

  function_name    = var.name
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  role             = module.lambda_role.arn
  handler          = var.handler
  timeout          = var.edge ? 5 : var.timeout
  runtime          = var.runtime
  publish          = var.edge ? true : var.publish
  memory_size      = var.memory_size
  layers           = local.layers
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = var.edge ? [] : ["hack"]
    content {
      variables = var.environment
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
    ]
  }
}

resource "aws_lambda_function" "lambda_source_file" {
  count = var.source_file != "" ? 1 : 0

  function_name    = var.name
  filename         = var.source_file
  source_code_hash = filebase64sha256(var.source_file)
  role             = module.lambda_role.arn
  handler          = var.handler
  timeout          = var.edge ? 5 : var.timeout
  runtime          = var.runtime
  publish          = var.edge ? true : var.publish
  memory_size      = var.memory_size
  layers           = local.layers
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = var.edge ? [] : ["hack"]
    content {
      variables = var.environment
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
    ]
  }
}

resource "aws_lambda_function" "lambda_external" {
  count = var.source_dir == "" && var.source_file == "" ? 1 : 0

  function_name    = var.name
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  role             = module.lambda_role.arn
  handler          = var.handler
  timeout          = var.edge ? 5 : var.timeout
  runtime          = var.runtime
  publish          = var.edge ? true : var.publish
  memory_size      = var.memory_size
  layers           = local.layers
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = var.edge ? [] : ["hack"]
    content {
      variables = var.environment
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      last_modified,
      layers,
    ]
  }
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = var.source_dir != "" ? var.source_dir : "${path.module}/default"
  output_path = "/tmp/terraform-artifacts/lambda-${var.name}.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.logs_retention_days
}

resource "aws_cloudwatch_log_subscription_filter" "subscription" {
  count = var.logs_destination_lambda_arn != "" ? 1 : 0

  name            = var.name
  log_group_name  = aws_cloudwatch_log_group.lambda.name
  filter_pattern  = var.logs_destination_filter_pattern
  destination_arn = var.logs_destination_lambda_arn
}
