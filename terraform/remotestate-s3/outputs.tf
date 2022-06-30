output "kms_key" {
  value       = module.remote_state.kms_key.key_id
}

output "state_bucket" {
  value       = module.remote_state.state_bucket.bucket
}