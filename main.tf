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

#Reserve a static IP address for the load balancer
resource "google_compute_global_address" "lb-ip" {
  name         = "lb-ip"
  address_type = "EXTERNAL"
}

resource "google_compute_backend_bucket" "backend" {
  name        = "website-backend"
  bucket_name = module.gcs_buckets.bucket.id
}

#Create a URL map for the load balancer
resource "google_compute_url_map" "url-map" {
  name = "http-lb"

  default_service = google_compute_backend_bucket.backend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher"
  }

  path_matcher {
    name            = "path-matcher"
    default_service = google_compute_backend_bucket.backend.id

    default_route_action {
      url_rewrite {
        path_prefix_rewrite = "/index.html"
      }
    }
  }
}

#Create a target HTTP proxy for the load balancer
resource "google_compute_target_http_proxy" "http-proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url-map.id
}

#Create a global forwarding rule
resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name                  = "website-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.http-proxy.id
  ip_address            = google_compute_global_address.lb-ip.id
}

#Create a health check for the backend service
resource "google_compute_http_health_check" "http-health-check" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 5
}