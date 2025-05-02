# Setup the providers
provider "google" {
  project = var.project_id
}

# Create a bucket for the website
module "bucket" {
  source      = "./modules/storage"
  project_id  = var.project_id
  bucket_name = "website"
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
  source      = "./modules/load-balancer"
  bucket_name = module.bucket.bucket.name
}
