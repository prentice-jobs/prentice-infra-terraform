# GCP Project Service
resource "google_project_service" "secretmanager_api" {
  project = var.gcp_project_id
  service = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudrun_api" {
  project = var.gcp_project_id
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin_api" {
  project = var.gcp_project_id
  service = "sqladmin.googleapis.com"
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


# https://cloud.google.com/sql/docs/postgres/connect-run
resource "google_cloud_run_v2_service" "prentice_webserver" {
  name = "prentice-jobs-webserver-dev"
  location = var.gcp_region
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    scaling {
      max_instance_count = 4
    }

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # Change to Prentice's Docker Image
      volume_mounts {
        name = "cloudsql"
        mount_path = "/cloudsql"
      }
      
      resources {
        limits = {
          cpu    = "4"
          memory = "4"
        }
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.prentice_db_instance.connection_name]
      }
    }
  }
  client = "terraform"
  depends_on = [
    google_project_service.secretmanager_api,
    google_project_service.cloudrun_api,
    google_project_service.sqladmin_api
  ]
}