
#Reserve a static IP address for the load balancer
resource "google_compute_global_address" "lb-ip" {
  name         = "lb-ip"
  address_type = "EXTERNAL"
}

#Create a backend bucket for the load balancer
resource "google_compute_backend_bucket" "backend" {
  name        = "website-backend"
  bucket_name = var.bucket_name
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
