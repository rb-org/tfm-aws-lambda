variable "prefix" {}

variable "default_tags" { type = "map" }

variable "region" {}

variable "duration" {
  description = "minimum = 180, default = 3600 (seconds)"
  default     = 300
}
