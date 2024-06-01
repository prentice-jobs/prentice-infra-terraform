# GCP Project Service
resource "google_project_service" "main" {
  project = var.gcp_project_id
  count              = length(local.services_list)
  service            = local.services_list[count.index]
  disable_on_destroy = false
}

resource "google_compute_network" "prentice_vpc" {
  project = var.gcp_project_id
  name = "prentice-jobs-vpc-dev"
  auto_create_subnetworks = true
}

resource "google_sql_database_instance" "prentice_db_instance" {
  project = var.gcp_project_id
  name = "prentice-jobs-db-instance-dev"
  database_version = "POSTGRES_15"
  region = var.gcp_region

  settings {
    tier = "db-f1-micro"
  }

  # NOTE - SET TO TRUE IN PRODUCTION. This enables Terraform to delete Cloud SQL instances
  deletion_protection = false
}

resource "google_sql_database" "prentice_db" {
  name = "prentice-jobs-db-dev"
  project = var.gcp_project_id
  instance = google_sql_database_instance.prentice_db_instance.name
  
}

