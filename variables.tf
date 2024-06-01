variable "bucket" {}
variable "prefix" {}
variable "credentials" {}

variable "gcp_service_key" {
  description = "GCP Service Account Key File"
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type = string
}

variable "gcp_region" {
  description = "GCP Project Region"
  type = string
  default = "asia-southeast2" # Jakarta
}

variable "gcs_backend_bucket" {
  description = "Cloud Storage Backend for Terraform State"
  type = string
}