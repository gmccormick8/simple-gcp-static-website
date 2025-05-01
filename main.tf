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

# Setup the providers
provider "google" {
  project = var.project_id
}
provider "random" {}

# Create a bucket for the website
module "bucket" {
  source = "./modules/storage"
  project_id = var.project_id
  bucket_name   = "website"
}

# Upload a simple index.html page to the bucket
resource "google_storage_bucket_object" "indexpage" {
  name         = "index.html"
  content      = "<html><body>Hello World!</body></html>"
  content_type = "text/html"
  bucket       = module.bucket.bucket.id
}

# Upload a simple 404 / error page to the bucket
resource "google_storage_bucket_object" "errorpage" {
  name         = "404.html"
  content      = "<html><body>404!</body></html>"
  content_type = "text/html"
  bucket       = module.bucket.bucket.id
}

# Create a load balancer for the website
module "load-balancer" {
  source = "./modules/load-balancer"
  bucket = module.bucket.bucket
}
