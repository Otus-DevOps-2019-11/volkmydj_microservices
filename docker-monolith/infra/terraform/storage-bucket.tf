provider "google" {
  project = var.project
  region  = var.region
}


module "storage-bucket-prod" {
  source   = "SweetOps/storage-bucket/google"
  version  = "0.3.0"
  name     = "storage-bucket-docker-prod"
  location = "europe-west1"
  #force_destroy = true
}


output storage-bucket_url-prod {
  value = "${module.storage-bucket-prod.url}"
}
