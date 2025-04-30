terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.30.0"
    }
  }

  backend "local" {
  }

  required_version = "~> 1.11.0"
}

#Setup the provider
provider "google" {
  project = var.project_id
}


module "gcs_buckets" {
  source        = "terraform-google-modules/cloud-storage/google"
  version       = "~> 10.0"
  project_id    = var.project_id
  names         = ["website"]
  location      = "US"
  storage_class = "STANDARD"

  set_viewer_roles         = true
  bucket_viewers = ["allusers"]
  public_access_prevention = false


  force_destroy = [true]
}

# Upload a simple index.html page to the bucket
resource "google_storage_bucket_object" "indexpage" {
  name         = "index.html"
  content      = "<html><body>Hello World!</body></html>"
  content_type = "text/html"
  bucket       = module.gcs_buckets.bucket_name.id
}

# Upload a simple 404 / error page to the bucket
resource "google_storage_bucket_object" "errorpage" {
  name         = "404.html"
  content      = "<html><body>404!</body></html>"
  content_type = "text/html"
  bucket       = module.gcs_buckets.bucket_name.id
}