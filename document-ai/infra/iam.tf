# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

data "google_project" "project" {}

resource "google_service_account" "doc_ai_form_function" {
  account_id   = local.function_name
  display_name = "Document AI Form Parser function"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "bq_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "doc_ai_user" {
  project = var.project_id
  role    = "roles/documentai.apiUser"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "cf_invoker" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "eventarc" {
  project = var.project_id
  role    = "roles/eventarc.admin"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "iam_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.doc_ai_form_function.email}"
}

resource "google_project_iam_member" "gcs_to_pubsub" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "event_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
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

