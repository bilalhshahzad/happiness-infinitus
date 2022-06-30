output "kms_key" {
  value       = aws_kms_key.this
}

output "kms_key_alias" {
  value       = aws_kms_key.this
}

output "state_bucket" {
  value       = aws_s3_bucket.state
}

output "replica_bucket" {
  value       = aws_s3_bucket.replica.*
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.lock
}

output "terraform_iam_policy" {
  value       = aws_iam_policy.terraform[0]
}
