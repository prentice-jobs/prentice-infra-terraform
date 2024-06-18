# GCP Provider
# Upload your Service Account credentials file to the machine running this Terraform workflow
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # To initialize the Terraform backend, run command:
  # terraform init -backend-config=backend.tfvars
  backend "gcs" {
    # Uses the backend tfvars, passed in during `terraform init`
    bucket      = var.bucket
    prefix      = var.prefix
    credentials = file(var.gcp_service_key)
  }
}


provider "google" {
  credentials = file(var.gcp_service_key)
  project     = var.gcp_project_id
  region      = var.gcp_region
} 