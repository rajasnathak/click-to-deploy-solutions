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
