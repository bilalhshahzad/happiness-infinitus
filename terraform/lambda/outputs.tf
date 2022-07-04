output "s3_bucket_id" {
  value = {for k, v in module.s3: k => v.s3_bucket_id}
}

output "iam_user_name" {
  value = {for k, v in module.users: k => v.iam_user_name}
}

output "iam_userpassword" {
  value = {for k, v in module.users: k => v.iam_userpassword}
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "lambda_layer_arn" {
  value = module.lambda.lambda_layer_arn
}