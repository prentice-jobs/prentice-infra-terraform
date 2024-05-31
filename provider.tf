# GCP Provider
# Upload your Service Account credentials file to the machine running this Terraform workflow

provider "google" {
  credentials = file(var.gcp_service_key)
  project = var.gcp_project_id
  region = var.gcp_region
} 