output "bucket" {
  value       = module.gcs_buckets.bucket
  description = "The bucket created by the module"
}