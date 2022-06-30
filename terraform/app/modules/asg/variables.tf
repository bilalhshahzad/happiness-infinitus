variable "aws_region" {
  description = ""
  type        = string
  default     = "us-east-1"
}

variable "remote_state_s3" {
  description = ""
  type        = string
  default     = "bilal-fixed-bucket-name-remote-state"
}

variable "remote_state_key" {
  description = ""
  type        = string
  default     = "mysite"
}

variable "remote_state_region" {
  description = ""
  type        = string
  default     = "us-east-1"
}

variable "base_tags" {
  description = ""
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  description = ""
  type        = map(string)
  default     = {}
}

variable "rdshost" {
  description = ""
  type        = string
  default     = null
}

variable "db_user" {
  description = ""
  type        = string
  nullable = false
}

variable "db_password" {
  description = ""
  type        = string
  nullable = false
}

variable "efsid" {
  description = ""
  type        = string
  default     = null
}

variable "sg_web_id" {
  description = ""
  type        = string
  default     = null
}

variable "subnet_public-a_id" {
  description = ""
  type        = string
  default     = null
}

variable "subnet_public-b_id" {
  description = ""
  type        = string
  default     = null
}

variable "lb_target_group_arn" {
  description = ""
  type        = string
  default     = null
}