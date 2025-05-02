output "website_url" {
  description = "Website URL"
  value = "http://${module.load-balancer.load_balancer_ip}"
}