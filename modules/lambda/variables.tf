variable "organization" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "purpose" {
  type = string
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 60
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "policy_arns" {
  type    = map(string)
  default = {}
}

# Path for ZIP deployment
variable "zip_file_path" {
  type    = string
  default = null
}

# URI for Image deployment
variable "image_uri" {
  type    = string
  default = null
}
