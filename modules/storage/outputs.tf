output "bucket" {
  description = "The bucket created by the module"
  value       = module.gcs_buckets.bucket
}