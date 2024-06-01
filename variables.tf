variable "bucket" {
  description = "GCS Bucket to store Terraform state"
  type = string
}

variable "prefix" {
  description = "Default prefix value for Terraform backend"
  type = string
}

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