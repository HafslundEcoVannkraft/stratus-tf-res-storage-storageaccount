variable "location" {
  type        = string
  description = "Location of the resources."
  default     = "norwayeast"
}

variable "code_name" {
  type        = string
  description = "The code name for the product team"
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment"
  default     = ""
}
