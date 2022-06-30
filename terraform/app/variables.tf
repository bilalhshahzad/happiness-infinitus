variable "aws_region" {
  description = ""
  type        = string
  default     = "us-east-1"
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

variable "custom_tags" {
  description = ""
  type        = map(string)
  default     = {}
}