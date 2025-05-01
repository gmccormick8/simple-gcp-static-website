output "website_url" {
  value = "http://${module.load-balancer.load_balancer_ip}"
}