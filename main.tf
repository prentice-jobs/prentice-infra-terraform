/** TODO 
  1. refactoring into modules, if time allows
  2. Setup VPC properly
*/

# DEVOPS
resource "google_artifact_registry_repository" "prentice-registry" {
  location      = "asia-southeast2" # Jakarta
  repository_id = "prentice-jobs-registry-dev"
  description   = "Prentice Jobs Web Server Registry"
  format        = "DOCKER"

  labels = {
    environment = "dev"
  }
}

# VPC
# resource "google_compute_network" "prentice_vpc" {
#   project = var.gcp_project_id
#   name = "prentice-jobs-vpc-dev"
#   auto_create_subnetworks = true
# }

# STORAGE
resource "google_storage_bucket" "prentice_bucket_offer_letter_dev" {
  name          = var.GCS_BUCKET_OFFER_LETTER
  location      = var.project_gcs_bucket_region
  force_destroy = false # DO NOT delete user data when destroying Terraform Infrastructure

  uniform_bucket_level_access = var.project_gcs_uniform_bucket_access

  soft_delete_policy {
    retention_duration_seconds = var.project_gcs_retention_seconds
  }
}

resource "google_storage_bucket" "prentice_bucket_stopwords_dev" {
  name          = var.GCS_BUCKET_STOPWORDS
  location      = var.project_gcs_bucket_region
  force_destroy = false

  uniform_bucket_level_access = var.project_gcs_uniform_bucket_access

  soft_delete_policy {
    retention_duration_seconds = var.project_gcs_retention_seconds
  }
}

resource "google_storage_bucket" "prentice_bucket_recsys_dev" {
  name = var.GCS_BUCKET_RECSYS
  location = var.project_gcs_bucket_region
  force_destroy = false

  uniform_bucket_level_access = var.project_gcs_uniform_bucket_access

  soft_delete_policy {
    retention_duration_seconds = var.project_gcs_retention_seconds
  }
}

# DATABASES
resource "google_sql_database_instance" "prentice_db_instance" {
  project          = var.gcp_project_id
  name             = "prentice-jobs-db-instance-dev"
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    tier = "db-f1-micro"
  }

  # NOTE - SET TO TRUE IN PRODUCTION. This enables Terraform to delete Cloud SQL instances
  deletion_protection = false
}

resource "google_sql_database" "prentice_db" {
  name     = "prentice-jobs-db-dev"
  project  = var.gcp_project_id
  instance = google_sql_database_instance.prentice_db_instance.name

}

# COMPUTE
# https://cloud.google.com/sql/docs/postgres/connect-run
# v1 documentation - https://stackoverflow.com/questions/57885584/cannot-deploy-public-api-on-cloud-run-using-terraform
resource "google_cloud_run_v2_service" "prentice_webserver" {
  name     = "prentice-jobs-webserver-dev"
  location = var.gcp_region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      max_instance_count = 4
    }

    containers {
      name  = "webserver"
      image = var.CLOUD_RUN_CONTAINER_PATH # Change to Prentice's Docker Image
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }

      env {
        name  = "ENV"
        value = var.ENV
      }

      env {
        name  = "POSTGRES_DB_PORT"
        value = var.POSTGRES_DB_PORT
      }

      env {
        name  = "POSTGRES_DB_HOST"
        value = var.POSTGRES_DB_HOST
      }

      env {
        name  = "POSTGRES_DB_NAME"
        value = var.POSTGRES_DB_NAME
      }

      env {
        name  = "POSTGRES_DB_USER"
        value = var.POSTGRES_DB_USER
      }

      env {
        name  = "POSTGRES_DB_PASSWORD"
        value = var.POSTGRES_DB_PASSWORD
      }

      env {
        name  = "GCS_BUCKET_OFFER_LETTER"
        value = var.GCS_BUCKET_OFFER_LETTER
      }

      env {
        name  = "GCS_BUCKET_STOPWORDS"
        value = var.GCS_BUCKET_STOPWORDS
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
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.prentice_webserver.location
  project  = google_cloud_run_v2_service.prentice_webserver.project
  service  = google_cloud_run_v2_service.prentice_webserver.name

  policy_data = data.google_iam_policy.noauth.policy_data
}