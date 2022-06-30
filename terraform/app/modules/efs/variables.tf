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

variable "sg_efs_id" {
  description = ""
  type        = string
  default     = null
}