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

variable "db_depends_on_sg_web" {
  description = ""
  type        = any
  default     = []
}
variable "sg_db_id" {
  description = ""
  type        = string
  default     = null
}

variable "subnet_private-a_id" {
  description = ""
  type        = string
  default     = null
}

variable "subnet_private-b_id" {
  description = ""
  type        = string
  default     = null
}

variable "vpc_id" {
  description = ""
  type        = string
  default     = null
}