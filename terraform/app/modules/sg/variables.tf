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

variable "vpc_id" {
  description = ""
  type        = string
  default     = null
}