variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "Google Cloud Region"
  default     = "europe-west3"
}

variable "zone" {
  type        = string
  description = "Google Cloud Zone"
  default     = "europe-west3-a"
}
