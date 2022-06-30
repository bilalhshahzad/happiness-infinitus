variable "tags" {
  type        = map(string)
  default = {
    env        = "dev"
    provisoner = "Gandalf"
    terraform  = "true"
  }
}

variable "terraform_iam_policy_create" {
  type        = bool
  default     = true
}

variable "terraform_iam_policy_name_prefix" {
  type        = string
  default     = "terraform"
}

variable "kms_key_alias" {
  type        = string
  default     = "gandalf-tf-remote-state-key"
}

variable "kms_key_description" {
  type        = string
  default     = "This key is used to encrypt the remote state bucket."
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  default     = 7
}

variable "kms_key_enable_key_rotation" {
  type        = bool
  default     = true
}

variable "enable_replication" {
  type        = bool
  default     = true
}

variable "state_bucket_prefix" {
  type        = string
  default     = "tf-remote-state"
}

variable "replica_bucket_prefix" {
  type        = string
  default     = "tf-remote-state-replica"
}

variable "iam_role_arn" {
  type        = string
  default     = null
}

variable "iam_role_name_prefix" {
  type        = string
  default     = "tf-remote-state-replication-role"
}

variable "iam_policy_name_prefix" {
  type        = string
  default     = "tf-remote-state-replication-policy"
}

variable "iam_policy_attachment_name" {
  type        = string
  default     = "tf-iam-role-attachment-replication-configuration"
}

variable "noncurrent_version_transitions" {
  type = list(object({
    days          = number
    storage_class = string
  }))

  default = [
    {
      days          = 7
      storage_class = "GLACIER"
    }
  ]
}

variable "noncurrent_version_expiration" {
  type = object({
    days = number
  })

  default = null
}

variable "s3_bucket_force_destroy" {
  type        = bool
  default     = false
}

variable "s3_logging_target_bucket" {
  type        = string
  default     = null
}

variable "s3_logging_target_prefix" {
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  type        = string
  default     = "tf-remote-state-lock"
}

variable "dynamodb_table_billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_enable_server_side_encryption" {
  type        = bool
  default     = false
}

variable "override_s3_bucket_name" {
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
}
variable "s3_bucket_name_replica" {
  type        = string
  default     = ""
}