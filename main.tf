terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.0"
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

provider "random" {}

resource "random_integer" "bucket_name_prefix" {
    min = 10000
    max = 9999999
}

module "gcs_buckets" {
  source        = "terraform-google-modules/cloud-storage/google"
  version       = "~> 10.0"
  project_id    = var.project_id
  names         = ["website"]
  prefix        = random_integer.bucket_name_prefix.result
  location      = "US"
  storage_class = "STANDARD"
  force_destroy = { "website" = true }
}

# Upload a simple index.html page to the bucket
resource "google_storage_bucket_object" "indexpage" {
  name         = "index.html"
  content      = "<html><body>Hello World!</body></html>"
  content_type = "text/html"
  bucket       = module.gcs_buckets.bucket.id
}

# Upload a simple 404 / error page to the bucket
resource "google_storage_bucket_object" "errorpage" {
  name         = "404.html"
  content      = "<html><body>404!</body></html>"
  content_type = "text/html"
  bucket       = module.gcs_buckets.bucket.id
}

# Make bucket public by granting allUsers storage.objectViewer access
resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = module.gcs_buckets.bucket.id
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}