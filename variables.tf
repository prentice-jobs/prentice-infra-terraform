variable "bucket" {
  description = "GCS Bucket to store Terraform state"
  type        = string
}

variable "prefix" {
  description = "Default prefix value for Terraform backend"
  type        = string
}

variable "gcp_service_key" {
  description = "GCP Service Account Key File"
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Project Region"
  type        = string
  default     = "asia-southeast2" # Jakarta
}

variable "project_gcs_bucket_region" {
  description = "GCS Bucket Region for Prentice App Bucket"
  type        = string
}

variable "project_gcs_uniform_bucket_access" {
  description = "Flag for allowing/disallowing uniform access to GCS Bucket resources"
  type        = bool
}

# ENV VARS
variable "ENV" {
  type = string
}

variable "POSTGRES_DB_PORT" {
  type = string
}

variable "POSTGRES_DB_HOST" {
  type = string
}

variable "POSTGRES_DB_NAME" {
  type = string
}

variable "POSTGRES_DB_USER" {
  type = string
}

variable "POSTGRES_DB_PASSWORD" {
  type = string
}

variable "GCS_BUCKET_OFFER_LETTER" {
  description = "GCS Bucket Name for Offer Letters"
  type = string
}

variable "CLOUD_RUN_CONTAINER_PATH" {
  type = string
}

variable "GCS_BUCKET_STOPWORDS" {
  description = "GCS Bucket Name for Keyword Extractor"
  type = string
}

variable "GCS_BUCKET_RECSYS" {
  description = "GCS Bucket Name for Recsys Vectorizer"
  type = string
}

variable "project_gcs_retention_seconds" {
  type = string
}