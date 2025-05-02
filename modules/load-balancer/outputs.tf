output "load_balancer_ip" {
  description = "Load Balancer IP Address"
  value       = google_compute_global_address.lb-ip.address
}