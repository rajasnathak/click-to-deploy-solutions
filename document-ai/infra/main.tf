resource "google_project_service" "apis" {
 for_each = toset([
   "cloudbuild.googleapis.com",
   "aiplatform.googleapis.com",
   "artifactregistry.googleapis.com",
   "bigquery.googleapis.com",
   "cloudfunctions.googleapis.com",
   "cloudresourcemanager.googleapis.com",
   "compute.googleapis.com",
   "documentai.googleapis.com",
   "iam.googleapis.com",
   "logging.googleapis.com",
   "pubsub.googleapis.com",
   "run.googleapis.com",
   "storage.googleapis.com",
   "storage-component.googleapis.com",
   "eventarc.googleapis.com",
   "eventarcpublishing.googleapis.com",
 ])
 service            = each.value
 disable_on_destroy = false
}

# Get the project number
data "google_project" "project" {
}

# Cloud Build Service Account
resource "google_project_iam_member" "cloud_build_editor" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role    = "roles/editor"
}

resource "google_project_iam_member" "cloud_build_security_admin" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role    = "roles/iam.securityAdmin"
}

resource "google_project_iam_member" "cloud_build_documentai_admin" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role    = "roles/documentai.admin"
}

resource "google_project_iam_member" "cloud_build_eventarc_admin" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  role    = "roles/eventarc.admin"
}

# Compute Service Account
resource "google_project_iam_member" "compute_editor" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  role    = "roles/editor"
}

resource "google_project_iam_member" "compute_storage_object_admin" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  role    = "roles/storage.objectAdmin"
}

resource "google_project_iam_member" "compute_security_admin" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  role    = "roles/iam.securityAdmin"
}

# Cloud Storage Service Account
data "google_project_service_identity" "gcs_service_account" {
  provider = google-beta
  service  = "kms.googleapis.com"
}

resource "google_project_iam_member" "gcs_pubsub_publisher" {
  project = var.project_id
  member  = "serviceAccount:${data.google_project_service_identity.gcs_service_account.email}"
  role    = "roles/pubsub.publisher"
}
